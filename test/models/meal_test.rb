require "test_helper"

class MealTest < ActiveSupport::TestCase
  # Validations

  test "valid meal with meal_type and date" do
    meal = users(:one).meals.build(meal_type: "breakfast", date: Date.current)
    assert meal.valid?
  end

  test "invalid without meal_type" do
    meal = users(:one).meals.build(date: Date.current)
    assert_not meal.valid?
    assert_includes meal.errors[:meal_type], "can't be blank"
  end

  test "invalid without date" do
    meal = users(:one).meals.build(meal_type: "lunch")
    assert_not meal.valid?
    assert_includes meal.errors[:date], "can't be blank"
  end

  # Enums

  test "meal_type enum includes expected values" do
    assert_equal %w[breakfast lunch dinner snack], Meal.meal_types.keys
  end

  test "meal_type predicate methods work" do
    assert meals(:breakfast).meal_type_breakfast?
    assert meals(:lunch).meal_type_lunch?
  end

  # Scopes

  test "on_date scope filters by date" do
    date = Date.new(2026, 3, 14)
    meals = Meal.on_date(date)
    meals.each { |m| assert_equal date, m.date }
  end

  test "today scope returns meals for today" do
    Meal.today.each { |m| assert_equal Date.current, m.date }
  end

  # Nutrition calculations

  test "total_calories sums calories from all meal_foods" do
    meal = meals(:breakfast)
    # chicken_breast: 165 * 1.5 = 247 + brown_rice: 216 * 1.0 = 216 -> 463
    assert_equal 463, meal.total_calories
  end

  test "total_protein sums protein from all meal_foods" do
    meal = meals(:breakfast)
    # chicken_breast: 31.0 * 1.5 = 46.5 + brown_rice: 5.0 * 1.0 = 5.0 -> 51.5
    assert_in_delta 51.5, meal.total_protein, 0.1
  end

  test "total_carbs sums carbs from all meal_foods" do
    meal = meals(:breakfast)
    # chicken: 0.0 * 1.5 = 0 + rice: 45.0 * 1.0 = 45.0 -> 45.0
    assert_in_delta 45.0, meal.total_carbs, 0.1
  end

  test "total_fat sums fat from all meal_foods" do
    meal = meals(:breakfast)
    # chicken: 3.6 * 1.5 = 5.4 + rice: 1.8 * 1.0 = 1.8 -> 7.2
    assert_in_delta 7.2, meal.total_fat, 0.1
  end

  test "nutrition_summary returns hash with all macro keys" do
    summary = meals(:breakfast).nutrition_summary
    assert summary.key?(:calories)
    assert summary.key?(:protein)
    assert summary.key?(:carbs)
    assert summary.key?(:fat)
  end

  test "total_calories returns 0 for meal with no foods" do
    meal = users(:one).meals.create!(meal_type: "snack", date: 10.days.ago)
    assert_equal 0, meal.total_calories
  end

  # Associations

  test "belongs to user" do
    assert_equal users(:one), meals(:breakfast).user
  end

  test "has many meal_foods" do
    assert meals(:breakfast).meal_foods.count == 2
  end

  test "has many foods through meal_foods" do
    assert meals(:breakfast).foods.include?(foods(:chicken_breast))
  end

  test "destroying meal cascades to meal_foods" do
    meal = meals(:breakfast)
    initial_count = meal.meal_foods.count
    assert initial_count > 0
    assert_difference "MealFood.count", -initial_count do
      meal.destroy
    end
  end
end
