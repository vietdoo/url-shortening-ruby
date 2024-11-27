require "test_helper"

class UrlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @url = urls(:one)
  end

  test "should get index" do
    get web_urls_url
    assert_response :success
  end

  test "should show url" do
    get web_short_url_url(@url.short_code)
    assert_response :success
  end

  test "should show result" do
    get web_shortened_url_result_url(id: @url.hash_id)
    assert_response :success
  end

  test "should not show expired url" do
    @url.update(time_expired: Time.now - 1.day)
    get web_short_url_url(@url.short_code)
    assert_response :success
    assert_match "URL not found or expired", @response.body
  end
end