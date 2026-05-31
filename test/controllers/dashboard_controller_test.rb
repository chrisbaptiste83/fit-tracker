require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects to login when not authenticated" do
    get root_path
    assert_redirected_to new_session_path
  end

  test "GET root returns success when authenticated" do
    sign_in(users(:one))
    get root_path
    assert_response :success
  end

  test "GET dashboard returns success when authenticated" do
    sign_in(users(:one))
    get dashboard_path
    assert_response :success
  end

  test "dashboard is accessible with full profile" do
    sign_in(users(:one))
    get root_path
    assert_response :success
  end

  test "dashboard is accessible with minimal profile (no fitness data)" do
    user = User.create!(email_address: "minimal@example.com", password: "StrongP@ss1234")
    sign_in(user, password: "StrongP@ss1234")
    get root_path
    assert_response :success
  end
end
