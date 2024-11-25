ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def create_and_update_url
      #delete all records have same short_code
      Url.where(short_code: "oivan").destroy_all
      url = Url.create!(
        original_url: "https://oivan.com/vietdoo",
        short_code: "oivan",
        time_init: Time.now,
        time_expired: Time.now + 30.days,
      )
      url
    end
  end
end
