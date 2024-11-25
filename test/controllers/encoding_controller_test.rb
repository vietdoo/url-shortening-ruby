require "test_helper"

class EncodingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_url = "https://example.com"
    @invalid_url = "invalid_url"
    @short_code = "short123"
    @invalid_short_code = "lậptrìnhruby"
    @existing_short_code = urls(:one).short_code
    @expiration_days = 30
  end

  test "should encode a valid URL" do
    post encode_url_path, params: { url: { original_url: @valid_url, expiration_days: @expiration_days } }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal "URL shortened successfully!", json_response["message"]
  end

  test "should not encode an invalid URL" do
    post encode_url_path, params: { url: { original_url: @invalid_url, expiration_days: @expiration_days } }
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Original url is not a valid URL", json_response["message"]
  end

  test "should encode a URL with a custom short code" do
    post encode_url_path, params: { url: { original_url: @valid_url, short_code: @short_code, expiration_days: @expiration_days } }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @short_code, json_response["data"]["short_code"]
  end

  test "should not encode a URL with an existing short code" do
    post encode_url_path, params: { url: { original_url: @valid_url, short_code: @existing_short_code, expiration_days: @expiration_days } }
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Shortcode already exists. Please try another one.", json_response["message"]
  end

  test "should encode a URL without an expiration date" do
    post encode_url_path, params: { url: { original_url: @valid_url } }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_nil json_response["data"]["time_expired"]
  end

  test "should encode a URL with an expiration date" do
    post encode_url_path, params: { url: { original_url: @valid_url, expiration_days: @expiration_days } }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_nil json_response["data"]["time_expired"]
  end

  test "should not encode a URL with a short code that is too short" do
    post encode_url_path, params: { url: { original_url: @valid_url, short_code: "abc", expiration_days: @expiration_days } }
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Short code is too short (minimum is 4 characters)", json_response["message"]
  end

  test "should not encode a URL with a short code that is too long" do
    post encode_url_path, params: { url: { original_url: @valid_url, short_code: "a" * 31, expiration_days: @expiration_days } }
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Short code is too long (maximum is 30 characters)", json_response["message"]
  end

  test "should not encode a URL with a missing original URL parameter" do
    post encode_url_path, params: { url: { short_code: @short_code, expiration_days: @expiration_days } }
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Original url can't be blank", json_response["message"]
  end

  test "should not encode a URL with an invalid expiration date" do
    post encode_url_path, params: { url: { original_url: @valid_url, expiration_days: "invalid" } }
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Expiration days must be a valid number", json_response["message"]
  end
  
  test "should not encode a URL with a short code that contains invalid characters" do
    post encode_url_path, params: { url: { original_url: @valid_url, short_code: @invalid_short_code, expiration_days: @expiration_days } }
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Short code must only contain letters and numbers", json_response["message"]
  end

end