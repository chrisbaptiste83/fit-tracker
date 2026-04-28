require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  # Validations

  test "valid recipe with name and instructions" do
    recipe = users(:one).recipes.build(name: "Test Recipe", instructions: "Cook it", servings: 2)
    assert recipe.valid?
  end

  test "invalid without name" do
    recipe = users(:one).recipes.build(instructions: "Cook it", servings: 2)
    assert_not recipe.valid?
    assert_includes recipe.errors[:name], "can't be blank"
  end

  test "invalid without instructions" do
    recipe = users(:one).recipes.build(name: "Test Recipe", servings: 2)
    assert_not recipe.valid?
    assert_includes recipe.errors[:instructions], "can't be blank"
  end

  test "invalid with zero servings" do
    recipe = users(:one).recipes.build(name: "Test", instructions: "Cook", servings: 0)
    assert_not recipe.valid?
    assert_includes recipe.errors[:servings], "must be greater than 0"
  end

  test "valid with nil servings" do
    recipe = users(:one).recipes.build(name: "Test", instructions: "Cook", servings: nil)
    assert recipe.valid?
  end

  # Scopes

  test "ai_generated scope returns only ai-generated recipes" do
    assert_includes Recipe.ai_generated, recipes(:protein_smoothie)
    assert_not_includes Recipe.ai_generated, recipes(:chicken_rice_bowl)
  end

  test "user_created scope returns only non-ai recipes" do
    assert_includes Recipe.user_created, recipes(:chicken_rice_bowl)
    assert_not_includes Recipe.user_created, recipes(:protein_smoothie)
  end

  # Instance methods

  test "total_time sums prep and cook time" do
    recipe = recipes(:chicken_rice_bowl) # prep=10, cook=25
    assert_equal 35, recipe.total_time
  end

  test "total_time handles nil prep/cook times" do
    recipe = users(:one).recipes.build(name: "Quick", instructions: "Do it")
    assert_equal 0, recipe.total_time
  end

  test "macros_summary returns formatted string" do
    recipe = recipes(:chicken_rice_bowl) # P:42.0 C:48.0 F:8.0
    assert_equal "P: 42.0g | C: 48.0g | F: 8.0g", recipe.macros_summary
  end

  # Search

  test "search finds recipes by name" do
    results = Recipe.search("Chicken")
    assert_includes results, recipes(:chicken_rice_bowl)
    assert_not_includes results, recipes(:protein_smoothie)
  end

  test "search finds recipes by description" do
    results = Recipe.search("breakfast")
    assert_includes results, recipes(:protein_smoothie)
  end

  # Associations

  test "belongs to user" do
    assert_equal users(:one), recipes(:chicken_rice_bowl).user
  end

  test "has many breakfast_meal_plan_days" do
    assert_respond_to recipes(:chicken_rice_bowl), :breakfast_meal_plan_days
  end
end
