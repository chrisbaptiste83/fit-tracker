ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests serially (parallelization has minitest 6 compatibility issues)
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module AuthenticationHelper
  # Signs in via the real sessions controller so the signed cookie is set correctly.
  def sign_in(user, password: "password")
    post session_path, params: { email_address: user.email_address, password: password }
  end

  def sign_out
    delete session_path
  end
end

class ActionDispatch::IntegrationTest
  include AuthenticationHelper
end
