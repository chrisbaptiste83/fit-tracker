require "test_helper"

class MealsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in(@user)
  end

  test "redirects to login when not authenticated" do
    sign_out
    get meals_path
    assert_redirected_to new_session_path
  end

  # GET /meals

  test "GET index returns success" do
    get meals_path
    assert_response :success
  end

  test "GET index accepts a date param" do
    get meals_path, params: { date: "2026-03-14" }
    assert_response :success
  end

  # GET /meals/:id

  test "GET show returns success for own meal" do
    get meal_path(meals(:breakfast))
    assert_response :success
  end

  test "GET show returns 404 for another user's meal" do
    get meal_path(meals(:other_user_meal))
    assert_response :not_found
  end

  # GET /meals/new

  test "GET new returns success" do
    get new_meal_path
    assert_response :success
  end

  # POST /meals

  test "POST create with valid params creates meal" do
    assert_difference "Meal.count", 1 do
      post meals_path, params: {
        meal: { meal_type: "snack", date: Date.current }
      }
    end
    assert_redirected_to nutrition_path(date: Date.current)
  end

  test "POST create assigns meal to current user" do
    post meals_path, params: {
      meal: { meal_type: "dinner", date: Date.current }
    }
    assert_equal @user, Meal.last.user
  end

  test "POST create with missing meal_type renders new" do
    assert_no_difference "Meal.count" do
      post meals_path, params: { meal: { date: Date.current } }
    end
    assert_response :unprocessable_entity
  end

  # PATCH /meals/:id

  test "PATCH update with valid params updates meal" do
    patch meal_path(meals(:breakfast)), params: {
      meal: { notes: "Updated notes" }
    }
    assert_redirected_to nutrition_path(date: meals(:breakfast).date)
    assert_equal "Updated notes", meals(:breakfast).reload.notes
  end

  test "PATCH update returns 404 for another user's meal" do
    patch meal_path(meals(:other_user_meal)), params: {
      meal: { notes: "Hacked" }
    }
    assert_response :not_found
  end

  # DELETE /meals/:id

  test "DELETE destroy removes the meal" do
    date = meals(:breakfast).date
    assert_difference "Meal.count", -1 do
      delete meal_path(meals(:breakfast))
    end
    assert_redirected_to nutrition_path(date: date)
  end

  test "DELETE destroy returns 404 for another user's meal" do
    delete meal_path(meals(:other_user_meal))
    assert_response :not_found
  end
end
