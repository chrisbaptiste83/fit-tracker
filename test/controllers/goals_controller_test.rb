require "test_helper"

class GoalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in(@user)
  end

  test "redirects to login when not authenticated" do
    sign_out
    get goals_path
    assert_redirected_to new_session_path
  end

  # GET /goals

  test "GET index returns success" do
    get goals_path
    assert_response :success
  end

  # GET /goals/:id

  test "GET show returns success for own goal" do
    get goal_path(goals(:active_weight_goal))
    assert_response :success
  end

  test "GET show returns 404 for another user's goal" do
    get goal_path(goals(:other_user_goal))
    assert_response :not_found
  end

  # GET /goals/new

  test "GET new returns success" do
    get new_goal_path
    assert_response :success
  end

  # POST /goals

  test "POST create with valid params creates goal and redirects" do
    assert_difference "Goal.count", 1 do
      post goals_path, params: {
        goal: {
          goal_type: "weight",
          target_value: 70.0,
          current_value: 80.0,
          unit: "kg",
          description: "Lose weight",
          start_date: Date.current,
          target_date: 3.months.from_now
        }
      }
    end
    assert_redirected_to goals_path
  end

  test "POST create assigns goal to current user" do
    post goals_path, params: {
      goal: {
        goal_type: "habit",
        target_value: 30.0,
        description: "30 day streak",
        start_date: Date.current,
        target_date: 1.month.from_now
      }
    }
    assert_equal @user, Goal.last.user
  end

  test "POST create with missing description renders new" do
    assert_no_difference "Goal.count" do
      post goals_path, params: {
        goal: {
          goal_type: "weight",
          target_value: 70.0,
          start_date: Date.current,
          target_date: 1.month.from_now
        }
      }
    end
    assert_response :unprocessable_entity
  end

  # GET /goals/:id/edit

  test "GET edit returns success for own goal" do
    get edit_goal_path(goals(:active_weight_goal))
    assert_response :success
  end

  # PATCH /goals/:id

  test "PATCH update with valid params updates goal" do
    patch goal_path(goals(:active_weight_goal)), params: {
      goal: { description: "Updated goal description" }
    }
    assert_redirected_to goals_path
    assert_equal "Updated goal description", goals(:active_weight_goal).reload.description
  end

  test "PATCH update returns 404 for another user's goal" do
    patch goal_path(goals(:other_user_goal)), params: {
      goal: { description: "Hacked" }
    }
    assert_response :not_found
  end

  # DELETE /goals/:id

  test "DELETE destroy removes the goal" do
    assert_difference "Goal.count", -1 do
      delete goal_path(goals(:active_weight_goal))
    end
    assert_redirected_to goals_path
  end

  test "DELETE destroy returns 404 for another user's goal" do
    delete goal_path(goals(:other_user_goal))
    assert_response :not_found
  end

  # PATCH /goals/:id/complete

  test "PATCH complete marks goal as completed" do
    goal = goals(:active_weight_goal)
    assert_nil goal.completed_at
    patch complete_goal_path(goal)
    assert_redirected_to goals_path
    assert_not_nil goal.reload.completed_at
  end
end
