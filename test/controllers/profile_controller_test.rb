require "test_helper"

class ProfileControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in(@user)
  end

  test "redirects to login when not authenticated" do
    sign_out
    get profile_path
    assert_redirected_to new_session_path
  end

  # GET /profile

  test "GET show returns success" do
    get profile_path
    assert_response :success
  end

  # GET /profile/edit

  test "GET edit returns success" do
    get edit_profile_path
    assert_response :success
  end

  # PATCH /profile

  test "PATCH update with valid params updates profile" do
    patch profile_path, params: {
      user: { weight: 78.5, age: 31, fitness_goal: "maintain" }
    }
    assert_redirected_to profile_path
    @user.reload
    assert_in_delta 78.5, @user.weight, 0.01
    assert_equal 31, @user.age
    assert @user.fitness_goal_maintain?
  end

  test "PATCH update height updates the value" do
    patch profile_path, params: {
      user: { height: 178.0 }
    }
    assert_redirected_to profile_path
    assert_in_delta 178.0, @user.reload.height, 0.01
  end

  test "PATCH update calorie goal updates correctly" do
    patch profile_path, params: {
      user: { daily_calorie_goal: 2200, protein_goal: 160, carb_goal: 220, fat_goal: 65 }
    }
    assert_redirected_to profile_path
    @user.reload
    assert_equal 2200, @user.daily_calorie_goal
    assert_equal 160, @user.protein_goal
  end

  test "profile update does not change email address via profile params" do
    # email_address is not in profile_params, should not be updated
    original_email = @user.email_address
    patch profile_path, params: {
      user: { weight: 80.0 }
    }
    assert_equal original_email, @user.reload.email_address
  end
end
