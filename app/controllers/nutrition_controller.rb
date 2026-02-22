class NutritionController < ApplicationController
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @meals = current_user.meals.on_date(@date).includes(meal_foods: :food)

    @nutrition_totals = {
      calories: @meals.sum(&:total_calories),
      protein: @meals.sum(&:total_protein),
      carbs: @meals.sum(&:total_carbs),
      fat: @meals.sum(&:total_fat)
    }

    @calorie_goal = current_user.daily_calorie_goal || current_user.tdee || 2000
    @protein_goal = current_user.protein_goal || 150
    @carb_goal = current_user.carb_goal || 250
    @fat_goal = current_user.fat_goal || 65

    # Weekly chart data
    @weekly_calories = (6.days.ago.to_date..Date.current).map do |date|
      day_meals = current_user.meals.on_date(date).includes(meal_foods: :food)
      [date.strftime("%a"), day_meals.sum(&:total_calories)]
    end.to_h
  end
end
