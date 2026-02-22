class MealFoodsController < ApplicationController
  before_action :set_meal
  before_action :set_meal_food, only: [:update, :destroy]

  def create
    @meal_food = @meal.meal_foods.build(meal_food_params)

    respond_to do |format|
      if @meal_food.save
        format.turbo_stream
        format.html { redirect_to @meal, notice: "Food added." }
      else
        format.html { redirect_to @meal, alert: "Could not add food." }
      end
    end
  end

  def update
    respond_to do |format|
      if @meal_food.update(meal_food_params)
        format.turbo_stream
        format.html { redirect_to @meal, notice: "Food updated." }
      else
        format.html { redirect_to @meal, alert: "Could not update food." }
      end
    end
  end

  def destroy
    @meal_food.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@meal_food) }
      format.html { redirect_to @meal, notice: "Food removed." }
    end
  end

  private

  def set_meal
    @meal = current_user.meals.find(params[:meal_id])
  end

  def set_meal_food
    @meal_food = @meal.meal_foods.find(params[:id])
  end

  def meal_food_params
    params.require(:meal_food).permit(:food_id, :servings)
  end
end
