require "test_helper"

class MealPlanDayTest < ActiveSupport::TestCase
  test "belongs to meal_plan" do
    assert_equal meal_plans(:week_plan), meal_plan_days(:monday).meal_plan
  end

  test "has breakfast recipe" do
    assert_equal recipes(:chicken_rice_bowl), meal_plan_days(:monday).breakfast_recipe
  end

  test "has lunch recipe" do
    assert_equal recipes(:chicken_rice_bowl), meal_plan_days(:monday).lunch_recipe
  end

  test "has dinner recipe" do
    assert_equal recipes(:chicken_rice_bowl), meal_plan_days(:monday).dinner_recipe
  end

  test "day_of_week is stored correctly" do
    assert_equal 1, meal_plan_days(:monday).day_of_week
  end

  test "snacks text is stored" do
    assert_equal "Apple, almonds", meal_plan_days(:monday).snacks
  end

  test "recipe associations can be nil" do
    day = meal_plans(:week_plan).meal_plan_days.build(day_of_week: 5)
    assert_nil day.breakfast_recipe_id
    assert_nil day.lunch_recipe_id
    assert_nil day.dinner_recipe_id
  end

  test "can update breakfast recipe" do
    day = meal_plan_days(:monday)
    day.update!(breakfast_recipe: recipes(:protein_smoothie))
    assert_equal recipes(:protein_smoothie), day.reload.breakfast_recipe
  end
end
