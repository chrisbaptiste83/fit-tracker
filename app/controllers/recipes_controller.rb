class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @recipes = current_user.recipes.order(created_at: :desc)
    @recipes = @recipes.search(params[:q]) if params[:q].present?
  end

  def show
  end

  def new
    @recipe = current_user.recipes.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: "Recipe created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe deleted."
  end

  def search
    @recipes = current_user.recipes.search(params[:q]).limit(10)
    render partial: "recipes/search_results", locals: { recipes: @recipes }
  end

  private

  def set_recipe
    @recipe = current_user.recipes.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :description, :instructions, :prep_time, :cook_time, :servings, :calories, :protein, :carbs, :fat, :image_url, :ai_generated)
  end
end
