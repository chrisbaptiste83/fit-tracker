require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @workout = workouts(:upcoming_workout)
    sign_in(@user)
  end

  test "index redirects unauthenticated users" do
    sign_out
    get workouts_url
    assert_redirected_to new_session_url
  end

  test "index renders successfully" do
    get workouts_url
    assert_response :success
  end

  test "show renders the workout" do
    get workout_url(@workout)
    assert_response :success
  end

  test "show is scoped to current user" do
    get workout_url(workouts(:bobs_workout))
    assert_response :not_found
  end

  test "new renders the form" do
    get new_workout_url
    assert_response :success
  end

  test "create saves a new workout" do
    assert_difference "Workout.count", 1 do
      post workouts_url, params: {
        workout: { name: "New Strength Session", scheduled_date: 1.week.from_now.to_date }
      }
    end
    assert_redirected_to workout_url(Workout.last)
  end

  test "create rejects missing name" do
    assert_no_difference "Workout.count" do
      post workouts_url, params: {
        workout: { name: "", scheduled_date: 1.week.from_now.to_date }
      }
    end
    assert_response :unprocessable_entity
  end

  test "complete marks workout as finished" do
    assert_nil @workout.completed_at
    patch complete_workout_url(@workout)
    assert_redirected_to workout_url(@workout)
    assert_not_nil @workout.reload.completed_at
  end

  test "update changes workout attributes" do
    patch workout_url(@workout), params: {
      workout: { name: "Updated Name" }
    }
    assert_redirected_to workout_url(@workout)
    assert_equal "Updated Name", @workout.reload.name
  end

  test "destroy deletes the workout" do
    assert_difference "Workout.count", -1 do
      delete workout_url(@workout)
    end
    assert_redirected_to workouts_url
  end
end
