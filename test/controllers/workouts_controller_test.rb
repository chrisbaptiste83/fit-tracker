require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    sign_in(@user)
  end

  # Authentication enforcement

  test "redirects to login when not authenticated" do
    sign_out
    get workouts_path
    assert_redirected_to new_session_path
  end

  # GET /workouts

  test "GET index returns success" do
    get workouts_path
    assert_response :success
  end

  # GET /workouts/:id

  test "GET show returns success for own workout" do
    get workout_path(workouts(:upcoming_workout))
    assert_response :success
  end

  test "GET show returns 404 for another user's workout" do
    get workout_path(workouts(:other_user_workout))
    assert_response :not_found
  end

  # GET /workouts/new

  test "GET new returns success" do
    get new_workout_path
    assert_response :success
  end

  # POST /workouts

  test "POST create with valid params creates workout and redirects" do
    assert_difference "Workout.count", 1 do
      post workouts_path, params: {
        workout: { name: "New Workout", scheduled_date: Date.current + 3.days, duration_minutes: 45 }
      }
    end
    assert_redirected_to workout_path(Workout.last)
  end

  test "POST create assigns workout to current user" do
    post workouts_path, params: {
      workout: { name: "My Workout", scheduled_date: Date.current + 2.days }
    }
    assert_equal @user, Workout.last.user
  end

  test "POST create with invalid params renders new with unprocessable_entity" do
    assert_no_difference "Workout.count" do
      post workouts_path, params: { workout: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  # GET /workouts/:id/edit

  test "GET edit returns success for own workout" do
    get edit_workout_path(workouts(:upcoming_workout))
    assert_response :success
  end

  test "GET edit returns 404 for another user's workout" do
    get edit_workout_path(workouts(:other_user_workout))
    assert_response :not_found
  end

  # PATCH /workouts/:id

  test "PATCH update with valid params updates workout" do
    patch workout_path(workouts(:upcoming_workout)), params: {
      workout: { name: "Updated Name" }
    }
    assert_redirected_to workout_path(workouts(:upcoming_workout))
    assert_equal "Updated Name", workouts(:upcoming_workout).reload.name
  end

  test "PATCH update with invalid params renders edit" do
    patch workout_path(workouts(:upcoming_workout)), params: {
      workout: { name: "" }
    }
    assert_response :unprocessable_entity
  end

  test "PATCH update returns 404 for another user's workout" do
    patch workout_path(workouts(:other_user_workout)), params: {
      workout: { name: "Hacked" }
    }
    assert_response :not_found
  end

  # DELETE /workouts/:id

  test "DELETE destroy removes the workout" do
    assert_difference "Workout.count", -1 do
      delete workout_path(workouts(:upcoming_workout))
    end
    assert_redirected_to workouts_path
  end

  test "DELETE destroy returns 404 for another user's workout" do
    delete workout_path(workouts(:other_user_workout))
    assert_response :not_found
  end

  # PATCH /workouts/:id/complete

  test "PATCH complete marks workout as completed" do
    workout = workouts(:upcoming_workout)
    assert_nil workout.completed_at
    patch complete_workout_path(workout)
    assert_redirected_to workout_path(workout)
    assert_not_nil workout.reload.completed_at
  end
end
