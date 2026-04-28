require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "index redirects unauthenticated users" do
    get dashboard_url
    assert_redirected_to new_session_url
  end

  test "index renders successfully when logged in" do
    sign_in(users(:alice))
    get dashboard_url
    assert_response :success
  end

  test "root path renders the dashboard" do
    sign_in(users(:alice))
    get root_url
    assert_response :success
  end
end
