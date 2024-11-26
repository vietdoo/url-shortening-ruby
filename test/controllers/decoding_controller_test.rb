require "test_helper"
require "benchmark/ips"

class DecodingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @url = create_and_update_url
    @valid_short_code = @url.short_code
    @invalid_short_code = "nonexistent"
  end

  test "should decode a valid short code" do
    post decode_url_path, params: { url: { short_code: @valid_short_code } }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal "URL decoded successfully!", json_response["message"]
    assert_equal @url.original_url, json_response["data"]["original_url"]
  end

  test "should not decode an invalid short code" do
    post decode_url_path, params: { url: { short_code: @invalid_short_code } }, as: :json
    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal "URL not found.", json_response["message"]
  end

  test "should not decode when short code parameter is missing" do
    post decode_url_path, params: { url: {} }, as: :json
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Missing parameter. Please provide a valid URL object.", json_response["message"]
  end

  test "should not decode an expired URL" do
    @url.update(time_expired: Time.now - 1.day)
    post decode_url_path, params: { url: { short_code: @valid_short_code } }, as: :json
    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal "URL has expired.", json_response["message"]
  end

  test "should include complete URL data in successful response" do
    post decode_url_path, params: { url: { short_code: @valid_short_code } }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    
    assert_not_nil json_response["data"]["original_url"]
    assert_not_nil json_response["data"]["short_url"]
    assert_not_nil json_response["data"]["short_code"]
    assert_not_nil json_response["data"]["time_expired"]
  end


  test "should decode a valid short code with a large number of URLs" do
    Benchmark.ips do |x|
      number_of_urls = 100
      x.config(time: 5, warmup: 2)
      x.report("encode #{number_of_urls} URLs") do
        number_of_urls.times do
          original_url = "https://oivan.com/#{rand(100)}"
          post encode_url_path, params: { url: { original_url: original_url, expiration_days: 30 } }, as: :json
          
          encode_result = JSON.parse(response.body)
          short_code = encode_result["data"]["short_code"]

          post decode_url_path, params: { url: { short_code: short_code } }, as: :json
          decode_result = JSON.parse(response.body)
          assert_equal original_url, decode_result["data"]["original_url"]
        end
      end
    end
  end
end