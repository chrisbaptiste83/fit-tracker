class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Fitness associations
  has_many :workouts, dependent: :destroy
  has_many :meals, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :meal_plans, dependent: :destroy
  has_many :progress_logs, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :ai_conversations, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Enums for fitness profile
  enum :fitness_goal, {
    lose_weight: "lose_weight",
    build_muscle: "build_muscle",
    maintain: "maintain",
    endurance: "endurance"
  }, prefix: true

  enum :activity_level, {
    sedentary: "sedentary",
    light: "light",
    moderate: "moderate",
    active: "active",
    very_active: "very_active"
  }, prefix: true

  enum :gender, {
    male: "male",
    female: "female",
    other: "other"
  }, prefix: true

  validates :email_address, presence: true, uniqueness: true

  # Calculate BMR using Mifflin-St Jeor equation
  def bmr
    return nil unless weight && height && age && gender

    if gender_male?
      (10 * weight) + (6.25 * height) - (5 * age) + 5
    else
      (10 * weight) + (6.25 * height) - (5 * age) - 161
    end
  end

  # Calculate TDEE based on activity level
  def tdee
    return nil unless bmr && activity_level

    multiplier = case activity_level
    when "sedentary" then 1.2
    when "light" then 1.375
    when "moderate" then 1.55
    when "active" then 1.725
    when "very_active" then 1.9
    else 1.2
    end

    (bmr * multiplier).round
  end

  # Get today's nutrition totals
  def today_nutrition
    today_meals = meals.where(date: Date.current).includes(meal_foods: :food)

    totals = { calories: 0, protein: 0, carbs: 0, fat: 0 }

    today_meals.each do |meal|
      meal.meal_foods.each do |mf|
        totals[:calories] += (mf.food.calories * mf.servings).to_i
        totals[:protein] += (mf.food.protein * mf.servings).to_f
        totals[:carbs] += (mf.food.carbs * mf.servings).to_f
        totals[:fat] += (mf.food.fat * mf.servings).to_f
      end
    end

    totals
  end

  # Get today's workout summary
  def today_workouts
    workouts.where(scheduled_date: Date.current)
  end
end
