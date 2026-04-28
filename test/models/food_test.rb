require "test_helper"

class FoodTest < ActiveSupport::TestCase
  test "requires name" do
    food = Food.new(calories: 100, serving_size: 100)
    assert_not food.valid?
    assert_includes food.errors[:name], "can't be blank"
  end

  test "requires calories" do
    food = Food.new(name: "Mystery Food", serving_size: 100)
    assert_not food.valid?
    assert_includes food.errors[:calories], "can't be blank"
  end

  test "rejects negative calories" do
    food = Food.new(name: "Bad Food", calories: -10, serving_size: 100)
    assert_not food.valid?
  end

  test "allows zero calories" do
    food = Food.new(name: "Sparkling Water", calories: 0, serving_size: 250)
    assert food.valid?
  end

  test "requires serving_size" do
    food = Food.new(name: "Mystery Food", calories: 100)
    assert_not food.valid?
    assert_includes food.errors[:serving_size], "can't be blank"
  end

  test "macros_summary formats protein, carbs, and fat" do
    food = foods(:chicken_breast)
    summary = food.macros_summary
    assert_match(/P: 31\.0g/, summary)
    assert_match(/C: 0\.0g/, summary)
    assert_match(/F: 3\.6g/, summary)
  end

  test "search finds food by name" do
    results = Food.search("Chicken")
    assert_includes results, foods(:chicken_breast)
    assert_not_includes results, foods(:brown_rice)
  end

  test "search finds food by brand" do
    results = Food.search("Fresh Produce")
    assert_includes results, foods(:banana)
    assert_not_includes results, foods(:chicken_breast)
  end

  test "search returns all foods matching a shared brand" do
    results = Food.search("Generic")
    assert_includes results, foods(:chicken_breast)
    assert_includes results, foods(:brown_rice)
  end
end
