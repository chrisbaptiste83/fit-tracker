require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in(@user)
  end

  test "redirects to login when not authenticated" do
    sign_out
    get recipes_path
    assert_redirected_to new_session_path
  end

  # GET /recipes

  test "GET index returns success" do
    get recipes_path
    assert_response :success
  end

  test "GET index with search query returns success" do
    get recipes_path, params: { q: "chicken" }
    assert_response :success
  end

  # GET /recipes/:id

  test "GET show returns success for own recipe" do
    get recipe_path(recipes(:chicken_rice_bowl))
    assert_response :success
  end

  test "GET show returns 404 for another user's recipe" do
    get recipe_path(recipes(:protein_smoothie))
    assert_response :not_found
  end

  # GET /recipes/new

  test "GET new returns success" do
    get new_recipe_path
    assert_response :success
  end

  # POST /recipes

  test "POST create with valid params creates recipe and redirects" do
    assert_difference "Recipe.count", 1 do
      post recipes_path, params: {
        recipe: {
          name: "New Recipe",
          instructions: "Mix and cook",
          servings: 2
        }
      }
    end
    assert_redirected_to recipe_path(Recipe.last)
  end

  test "POST create assigns recipe to current user" do
    post recipes_path, params: {
      recipe: { name: "Mine", instructions: "Cook", servings: 1 }
    }
    assert_equal @user, Recipe.last.user
  end

  test "POST create with missing name renders new" do
    assert_no_difference "Recipe.count" do
      post recipes_path, params: {
        recipe: { instructions: "Cook it", servings: 2 }
      }
    end
    assert_response :unprocessable_entity
  end

  # PATCH /recipes/:id

  test "PATCH update with valid params updates recipe" do
    patch recipe_path(recipes(:chicken_rice_bowl)), params: {
      recipe: { name: "Updated Bowl" }
    }
    assert_redirected_to recipe_path(recipes(:chicken_rice_bowl))
    assert_equal "Updated Bowl", recipes(:chicken_rice_bowl).reload.name
  end

  test "PATCH update returns 404 for another user's recipe" do
    patch recipe_path(recipes(:protein_smoothie)), params: {
      recipe: { name: "Hacked" }
    }
    assert_response :not_found
  end

  # DELETE /recipes/:id

  test "DELETE destroy removes the recipe" do
    assert_difference "Recipe.count", -1 do
      delete recipe_path(recipes(:chicken_rice_bowl))
    end
    assert_redirected_to recipes_path
  end

  test "DELETE destroy returns 404 for another user's recipe" do
    delete recipe_path(recipes(:protein_smoothie))
    assert_response :not_found
  end

  # GET /recipes/search

  test "GET search returns success with matching results" do
    get search_recipes_path, params: { q: "Chicken" }
    assert_response :success
  end
end
