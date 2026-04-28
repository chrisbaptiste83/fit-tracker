require "test_helper"

class MealTest < ActiveSupport::TestCase
  test "requires meal_type" do
    meal = Meal.new(user: users(:alice), date: Date.current)
    assert_not meal.valid?
    assert_includes meal.errors[:meal_type], "can't be blank"
  end

  test "requires date" do
    meal = Meal.new(user: users(:alice), meal_type: :breakfast)
    assert_not meal.valid?
    assert_includes meal.errors[:date], "can't be blank"
  end

  test "total_calories sums food calories multiplied by servings" do
    meal = meals(:alice_breakfast)
    # chicken_breast: 165 * 1.5 = 247 (as integer)
    # brown_rice: 216 * 1.0 = 216
    # total = 463
    assert_equal 463, meal.total_calories
  end

  test "total_protein sums protein across all foods" do
    meal = meals(:alice_breakfast)
    # chicken: 31.0 * 1.5 = 46.5
    # rice: 5.0 * 1.0 = 5.0
    # total = 51.5
    assert_in_delta 51.5, meal.total_protein, 0.1
  end

  test "total_carbs sums carbs across all foods" do
    meal = meals(:alice_breakfast)
    # chicken: 0.0 * 1.5 = 0.0
    # rice: 45.0 * 1.0 = 45.0
    assert_in_delta 45.0, meal.total_carbs, 0.1
  end

  test "total_fat sums fat across all foods" do
    meal = meals(:alice_breakfast)
    # chicken: 3.6 * 1.5 = 5.4
    # rice: 1.8 * 1.0 = 1.8
    assert_in_delta 7.2, meal.total_fat, 0.1
  end

  test "nutrition_summary returns hash with all four macros" do
    summary = meals(:alice_breakfast).nutrition_summary
    assert_equal %i[calories protein carbs fat].sort, summary.keys.sort
  end

  test "on_date scope filters meals by date" do
    results = Meal.on_date(Date.parse("2026-03-01"))
    assert_includes results, meals(:alice_breakfast)
    assert_includes results, meals(:alice_lunch)
  end
end
