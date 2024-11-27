require "test_helper"

class HistoryControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get user_history_urls_url
    assert_response :success
  end

  test "should redirect if not signed in" do
    sign_out @user
    get users_history_urls_url
    assert_redirected_to new_user_session_url
  end

  
end