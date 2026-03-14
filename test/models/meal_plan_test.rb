require "test_helper"

class MealPlanTest < ActiveSupport::TestCase
  # Validations

  test "valid meal plan with week_start_date" do
    plan = users(:one).meal_plans.build(week_start_date: Date.current.beginning_of_week)
    assert plan.valid?
  end

  test "invalid without week_start_date" do
    plan = users(:one).meal_plans.build
    assert_not plan.valid?
    assert_includes plan.errors[:week_start_date], "can't be blank"
  end

  # Scopes

  test "ai_generated scope returns only ai-generated plans" do
    assert_includes MealPlan.ai_generated, meal_plans(:ai_week_plan)
    assert_not_includes MealPlan.ai_generated, meal_plans(:week_plan)
  end

  test "current_week scope returns plans for the current week's start date" do
    plan = users(:one).meal_plans.create!(week_start_date: Date.current.beginning_of_week)
    assert_includes MealPlan.current_week, plan
  end

  test "upcoming scope returns plans from this week forward" do
    old_plan = users(:one).meal_plans.create!(week_start_date: 2.weeks.ago.beginning_of_week)
    upcoming = MealPlan.upcoming
    assert_not_includes upcoming, old_plan
  end

  # Instance methods

  test "week_end_date is 6 days after week_start_date" do
    plan = meal_plans(:week_plan) # week_start_date: 2026-03-09
    assert_equal Date.new(2026, 3, 9) + 6.days, plan.week_end_date
  end

  test "date_range returns formatted string" do
    plan = meal_plans(:week_plan) # 2026-03-09 to 2026-03-15
    assert_kind_of String, plan.date_range
    assert plan.date_range.include?("Mar")
  end

  test "build_days creates 7 day entries" do
    plan = users(:one).meal_plans.build(week_start_date: Date.current.beginning_of_week)
    plan.build_days
    assert_equal 7, plan.meal_plan_days.length
  end

  test "build_days does not duplicate existing days" do
    plan = meal_plans(:week_plan)
    existing_days = plan.meal_plan_days.map(&:day_of_week)
    plan.build_days
    plan.meal_plan_days.each do |day|
      assert_equal 1, plan.meal_plan_days.count { |d| d.day_of_week == day.day_of_week }
    end
  end

  # Associations

  test "belongs to user" do
    assert_equal users(:one), meal_plans(:week_plan).user
  end

  test "has many meal_plan_days" do
    assert meal_plans(:week_plan).meal_plan_days.count >= 1
  end

  test "destroying meal_plan cascades to meal_plan_days" do
    plan = meal_plans(:week_plan)
    initial_days = plan.meal_plan_days.count
    assert initial_days > 0
    assert_difference "MealPlanDay.count", -initial_days do
      plan.destroy
    end
  end
end
