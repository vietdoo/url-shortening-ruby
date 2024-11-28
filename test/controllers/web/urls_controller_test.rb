require "test_helper"

class UrlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @url = urls(:one)
  end

  test "should show url and redirect to original_url" do
    @url.update(time_expired: Time.now + 1.day)
    get short_url_url(@url.short_code)
    assert_redirected_to @url.original_url
  end

  test "should render 404 for non-existent short_code" do
    get short_url_url("nonexistent")
    assert_response :not_found
  end

  test "should render 404 for expired url" do
    @url.update(time_expired: Time.now - 1.day)
    get short_url_url(@url.short_code)
    assert_response :not_found
  end
end