require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  # GET /registration/new

  test "GET new returns success" do
    get new_registration_path
    assert_response :success
  end

  test "GET new is accessible without authentication" do
    # No sign_in — should still work
    get new_registration_path
    assert_response :success
  end

  # POST /registration

  test "POST create with valid params creates user and redirects to root" do
    assert_difference "User.count", 1 do
      post registration_path, params: {
        user: {
          email_address: "newuser@example.com",
          password: "securepassword",
          password_confirmation: "securepassword"
        }
      }
    end
    assert_redirected_to root_path
  end

  test "POST create signs in the new user" do
    post registration_path, params: {
      user: {
        email_address: "autologin@example.com",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }
    follow_redirect!
    assert_response :success
  end

  test "POST create with mismatched passwords renders new" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email_address: "test@example.com",
          password: "password1",
          password_confirmation: "password2"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "POST create with duplicate email renders new" do
    existing = users(:one)
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email_address: existing.email_address,
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "POST create with missing email renders new" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: { password: "password", password_confirmation: "password" }
      }
    end
    assert_response :unprocessable_entity
  end
end
