require "test_helper"

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:one))
  end

  test "redirects to login when not authenticated" do
    sign_out
    get exercises_path
    assert_redirected_to new_session_path
  end

  # GET /exercises

  test "GET index returns success" do
    get exercises_path
    assert_response :success
  end

  test "GET index filters by category" do
    get exercises_path, params: { category: "strength" }
    assert_response :success
  end

  test "GET index filters by muscle_group" do
    get exercises_path, params: { muscle_group: "chest" }
    assert_response :success
  end

  test "GET index filters by difficulty" do
    get exercises_path, params: { difficulty: "beginner" }
    assert_response :success
  end

  test "GET index filters by search query" do
    get exercises_path, params: { q: "bench" }
    assert_response :success
  end

  # GET /exercises/:id

  test "GET show returns success for any exercise" do
    get exercise_path(exercises(:bench_press))
    assert_response :success
  end

  test "GET show returns 404 for non-existent exercise" do
    get exercise_path(id: 999999)
    assert_response :not_found
  end

  # GET /exercises/search

  test "GET search returns success" do
    get search_exercises_path, params: { q: "squat" }
    assert_response :success
  end
end
