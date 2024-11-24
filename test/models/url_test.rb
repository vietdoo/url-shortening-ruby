require "test_helper"

class UrlTest < ActiveSupport::TestCase
  test "should not save url with invalid original_url" do
    url = Url.new(original_url: "invalid_url", short_code: "short123")
    assert_not url.save, "Saved the url with an invalid original_url"
  end

  test "should save url with valid original_url" do
    url = Url.new(original_url: "https://example.com", short_code: "short123")
    assert url.save, "Failed to save the url with a valid original_url"
  end
end
