class DashboardController < ApplicationController
  def index
    @today_nutrition = current_user.today_nutrition
    @today_workouts = current_user.today_workouts
    @upcoming_workouts = current_user.workouts.upcoming.limit(5)
    @active_goals = current_user.goals.active.limit(4)
    @recent_progress = current_user.progress_logs.recent.first

    # Weekly data for charts
    @weekly_calories = current_user.meals
      .where(date: 7.days.ago.to_date..Date.current)
      .includes(meal_foods: :food)
      .group_by(&:date)
      .transform_values { |meals| meals.sum(&:total_calories) }

    @weekly_workouts = current_user.workouts
      .where(scheduled_date: 7.days.ago.to_date..Date.current)
      .completed
      .group(:scheduled_date)
      .count
  end
end
