require "test_helper"

class MealPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in(@user)
  end

  test "redirects to login when not authenticated" do
    sign_out
    get meal_plans_path
    assert_redirected_to new_session_path
  end

  # GET /meal_plans

  test "GET index returns success" do
    get meal_plans_path
    assert_response :success
  end

  # GET /meal_plans/:id

  test "GET show returns success for own meal plan" do
    get meal_plan_path(meal_plans(:week_plan))
    assert_response :success
  end

  test "GET show returns 404 for another user's meal plan" do
    get meal_plan_path(meal_plans(:ai_week_plan))
    assert_response :not_found
  end

  # GET /meal_plans/new

  test "GET new returns success" do
    get new_meal_plan_path
    assert_response :success
  end

  # POST /meal_plans

  test "POST create with valid params creates meal plan" do
    assert_difference "MealPlan.count", 1 do
      post meal_plans_path, params: {
        meal_plan: {
          week_start_date: 2.weeks.from_now.beginning_of_week.to_date,
          notes: "Upcoming plan"
        }
      }
    end
    assert_redirected_to meal_plan_path(MealPlan.last)
  end

  test "POST create assigns meal plan to current user" do
    post meal_plans_path, params: {
      meal_plan: { week_start_date: 3.weeks.from_now.beginning_of_week.to_date }
    }
    assert_equal @user, MealPlan.last.user
  end

  test "POST create with missing week_start_date renders new" do
    assert_no_difference "MealPlan.count" do
      post meal_plans_path, params: { meal_plan: { notes: "No date" } }
    end
    assert_response :unprocessable_entity
  end

  # PATCH /meal_plans/:id

  test "PATCH update with valid params updates meal plan" do
    patch meal_plan_path(meal_plans(:week_plan)), params: {
      meal_plan: { notes: "Updated notes" }
    }
    assert_redirected_to meal_plan_path(meal_plans(:week_plan))
    assert_equal "Updated notes", meal_plans(:week_plan).reload.notes
  end

  test "PATCH update returns 404 for another user's plan" do
    patch meal_plan_path(meal_plans(:ai_week_plan)), params: {
      meal_plan: { notes: "Hacked" }
    }
    assert_response :not_found
  end

  # DELETE /meal_plans/:id

  test "DELETE destroy removes the meal plan" do
    assert_difference "MealPlan.count", -1 do
      delete meal_plan_path(meal_plans(:week_plan))
    end
    assert_redirected_to meal_plans_path
  end

  test "DELETE destroy returns 404 for another user's plan" do
    delete meal_plan_path(meal_plans(:ai_week_plan))
    assert_response :not_found
  end
end
