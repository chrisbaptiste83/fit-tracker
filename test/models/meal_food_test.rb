require "test_helper"

class MealFoodTest < ActiveSupport::TestCase
  # Validations

  test "valid with positive servings" do
    mf = MealFood.new(meal: meals(:lunch), food: foods(:banana), servings: 1.0)
    assert mf.valid?
  end

  test "invalid without servings" do
    mf = MealFood.new(meal: meals(:lunch), food: foods(:banana))
    assert_not mf.valid?
    assert_includes mf.errors[:servings], "can't be blank"
  end

  test "invalid with zero servings" do
    mf = MealFood.new(meal: meals(:lunch), food: foods(:banana), servings: 0)
    assert_not mf.valid?
    assert_includes mf.errors[:servings], "must be greater than 0"
  end

  test "invalid with negative servings" do
    mf = MealFood.new(meal: meals(:lunch), food: foods(:banana), servings: -1)
    assert_not mf.valid?
  end

  # Calorie and macro calculations

  test "calories multiplies food calories by servings" do
    mf = meal_foods(:breakfast_chicken)
    # chicken_breast: 165 cal * 1.5 servings = 247
    assert_equal 247, mf.calories
  end

  test "protein multiplies food protein by servings" do
    mf = meal_foods(:breakfast_chicken)
    # 31.0 * 1.5 = 46.5
    assert_in_delta 46.5, mf.protein, 0.01
  end

  test "carbs multiplies food carbs by servings" do
    mf = meal_foods(:breakfast_rice)
    # brown_rice: 45.0 * 1.0 = 45.0
    assert_in_delta 45.0, mf.carbs, 0.01
  end

  test "fat multiplies food fat by servings" do
    mf = meal_foods(:breakfast_rice)
    # brown_rice: 1.8 * 1.0 = 1.8
    assert_in_delta 1.8, mf.fat, 0.01
  end

  test "calories scales with servings" do
    mf = meal_foods(:lunch_item)
    # banana: 105 * 2.0 = 210
    assert_equal 210, mf.calories
  end

  # Associations

  test "belongs to meal" do
    assert_equal meals(:breakfast), meal_foods(:breakfast_chicken).meal
  end

  test "belongs to food" do
    assert_equal foods(:chicken_breast), meal_foods(:breakfast_chicken).food
  end
end
