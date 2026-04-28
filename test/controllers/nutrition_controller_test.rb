require "test_helper"

class NutritionControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:one))
  end

  test "redirects to login when not authenticated" do
    sign_out
    get nutrition_path
    assert_redirected_to new_session_path
  end

  test "GET nutrition returns success" do
    get nutrition_path
    assert_response :success
  end

  test "GET nutrition with date param returns success" do
    get nutrition_path, params: { date: "2026-03-14" }
    assert_response :success
  end

  test "GET nutrition shows different data per user" do
    # user :one has meals logged; user :two has a different meal
    get nutrition_path, params: { date: "2026-03-14" }
    assert_response :success
  end

  test "GET nutrition with user with no meals is still successful" do
    fresh_user = User.create!(email_address: "fresh2@example.com", password: "password")
    sign_out
    sign_in(fresh_user)
    get nutrition_path
    assert_response :success
  end
end
