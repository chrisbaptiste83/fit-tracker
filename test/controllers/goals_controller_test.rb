require "test_helper"

class GoalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @goal = goals(:weight_loss)
    sign_in(@user)
  end

  test "index redirects unauthenticated users" do
    sign_out
    get goals_url
    assert_redirected_to new_session_url
  end

  test "index renders successfully" do
    get goals_url
    assert_response :success
  end

  test "show renders the goal" do
    get goal_url(@goal)
    assert_response :success
  end

  test "new renders the form" do
    get new_goal_url
    assert_response :success
  end

  test "create saves a new goal" do
    assert_difference "Goal.count", 1 do
      post goals_url, params: {
        goal: {
          goal_type: :strength,
          target_value: 80.0,
          current_value: 60.0,
          unit: "kg",
          start_date: Date.current,
          target_date: 6.months.from_now.to_date,
          description: "Deadlift 80kg"
        }
      }
    end
    assert_redirected_to goal_url(Goal.last)
  end

  test "complete marks the goal as done" do
    assert_not @goal.completed?
    patch complete_goal_url(@goal)
    assert_redirected_to goal_url(@goal)
    assert @goal.reload.completed?
  end

  test "destroy deletes the goal" do
    assert_difference "Goal.count", -1 do
      delete goal_url(@goal)
    end
    assert_redirected_to goals_url
  end
end
