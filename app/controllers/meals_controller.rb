class MealsController < ApplicationController
  before_action :set_meal, only: [:show, :edit, :update, :destroy]

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @meals = current_user.meals.on_date(@date).includes(meal_foods: :food)
  end

  def show
    @meal_foods = @meal.meal_foods.includes(:food)
  end

  def new
    @meal = current_user.meals.build(date: Date.current, meal_type: params[:type] || "breakfast")
    @foods = Food.order(:name).limit(50)
  end

  def create
    @meal = current_user.meals.build(meal_params)

    if @meal.save
      redirect_to nutrition_path(date: @meal.date), notice: "Meal logged successfully."
    else
      @foods = Food.order(:name).limit(50)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @foods = Food.order(:name).limit(50)
  end

  def update
    if @meal.update(meal_params)
      redirect_to nutrition_path(date: @meal.date), notice: "Meal updated."
    else
      @foods = Food.order(:name).limit(50)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    date = @meal.date
    @meal.destroy
    redirect_to nutrition_path(date: date), notice: "Meal deleted."
  end

  private

  def set_meal
    @meal = current_user.meals.find(params[:id])
  end

  def meal_params
    params.require(:meal).permit(:meal_type, :date, :notes)
  end
end
