require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new renders the registration form" do
    get new_registration_url
    assert_response :success
  end

  test "create registers a new user and redirects to root" do
    assert_difference "User.count", 1 do
      post registration_url, params: {
        user: {
          email_address: "newuser@example.com",
          password: "securepassword",
          password_confirmation: "securepassword"
        }
      }
    end
    assert_redirected_to root_url
  end

  test "create normalizes email to lowercase on registration" do
    post registration_url, params: {
      user: {
        email_address: "NewUser@Example.COM",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }
    assert_equal "newuser@example.com", User.last.email_address
  end

  test "create rejects blank email address" do
    assert_no_difference "User.count" do
      post registration_url, params: {
        user: { email_address: "", password: "securepassword", password_confirmation: "securepassword" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "create rejects duplicate email address" do
    assert_no_difference "User.count" do
      post registration_url, params: {
        user: {
          email_address: users(:alice).email_address,
          password: "securepassword",
          password_confirmation: "securepassword"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
