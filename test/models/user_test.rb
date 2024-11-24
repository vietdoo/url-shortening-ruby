require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user with invalid email" do
    user = User.new(email: "invalid_email", password: "password")
    assert_not user.save, "Saved the user with an invalid email"
  end

  test "should save user with valid email" do
    user = User.new(email: "qrweaa@gmail.com", password: "password")
    assert user.save, "Failed to save the user with a valid email"
  end
end
