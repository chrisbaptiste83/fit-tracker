class MealPlansController < ApplicationController
  before_action :set_meal_plan, only: [:show, :edit, :update, :destroy]

  def index
    @meal_plans = current_user.meal_plans.upcoming.includes(meal_plan_days: [:breakfast_recipe, :lunch_recipe, :dinner_recipe])
    @current_plan = current_user.meal_plans.current_week.first
  end

  def show
    @meal_plan_days = @meal_plan.meal_plan_days.includes(:breakfast_recipe, :lunch_recipe, :dinner_recipe)
  end

  def new
    @meal_plan = current_user.meal_plans.build(week_start_date: Date.current.next_week.beginning_of_week)
    @meal_plan.build_days
    @recipes = current_user.recipes.order(:name)
  end

  def create
    @meal_plan = current_user.meal_plans.build(meal_plan_params)

    if @meal_plan.save
      redirect_to @meal_plan, notice: "Meal plan created successfully."
    else
      @recipes = current_user.recipes.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @meal_plan.build_days
    @recipes = current_user.recipes.order(:name)
  end

  def update
    if @meal_plan.update(meal_plan_params)
      redirect_to @meal_plan, notice: "Meal plan updated."
    else
      @recipes = current_user.recipes.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meal_plan.destroy
    redirect_to meal_plans_path, notice: "Meal plan deleted."
  end

  private

  def set_meal_plan
    @meal_plan = current_user.meal_plans.find(params[:id])
  end

  def meal_plan_params
    params.require(:meal_plan).permit(:week_start_date, :notes, :ai_generated,
      meal_plan_days_attributes: [:id, :day_of_week, :breakfast_recipe_id, :lunch_recipe_id, :dinner_recipe_id, :snacks])
  end
end
