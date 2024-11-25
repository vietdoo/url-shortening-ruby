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
      url = Url.create!(
        original_url: "https://oivan.com/",
        short_code: "oivan",
        time_init: Time.now,
        time_expired: Time.now + 30.days
      )
      urls(:one).update(
        original_url: url.original_url,
        short_code: url.short_code,
        time_init: url.time_init,
        time_expired: url.time_expired
      )
      url
    end
  end
end
