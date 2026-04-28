require "test_helper"

class FoodTest < ActiveSupport::TestCase
  test "food fixture loads correctly" do
    food = foods(:chicken_breast)
    assert_equal "Chicken Breast", food.name
    assert_equal 165, food.calories
    assert_in_delta 31.0, food.protein, 0.01
    assert_in_delta 0.0, food.carbs, 0.01
    assert_in_delta 3.6, food.fat, 0.01
  end

  test "food with all macros" do
    food = foods(:brown_rice)
    assert_equal "Brown Rice", food.name
    assert_equal 216, food.calories
    assert food.protein > 0
    assert food.carbs > 0
    assert food.fat > 0
    assert food.fiber > 0
  end

  test "food can have nil brand" do
    food = foods(:banana)
    assert_nil food.brand
  end

  test "food has many meal_foods" do
    assert_respond_to foods(:chicken_breast), :meal_foods
    assert foods(:chicken_breast).meal_foods.count >= 1
  end

  test "food has many meals through meal_foods" do
    assert_respond_to foods(:chicken_breast), :meals
  end

  test "new food persists with valid attributes" do
    food = Food.create!(
      name: "Oat Flakes",
      serving_size: 40.0,
      serving_unit: "g",
      calories: 150,
      protein: 5.0,
      carbs: 27.0,
      fat: 3.0
    )
    assert food.persisted?
    assert_equal "Oat Flakes", food.name
  end
end
