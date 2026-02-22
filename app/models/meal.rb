class Meal < ApplicationRecord
  belongs_to :user
  has_many :meal_foods, dependent: :destroy
  has_many :foods, through: :meal_foods

  enum :meal_type, {
    breakfast: "breakfast",
    lunch: "lunch",
    dinner: "dinner",
    snack: "snack"
  }, prefix: true

  validates :meal_type, presence: true
  validates :date, presence: true

  scope :on_date, ->(date) { where(date: date) }
  scope :today, -> { where(date: Date.current) }

  def total_calories
    meal_foods.includes(:food).sum { |mf| (mf.food.calories * mf.servings).to_i }
  end

  def total_protein
    meal_foods.includes(:food).sum { |mf| (mf.food.protein.to_f * mf.servings).round(1) }
  end

  def total_carbs
    meal_foods.includes(:food).sum { |mf| (mf.food.carbs.to_f * mf.servings).round(1) }
  end

  def total_fat
    meal_foods.includes(:food).sum { |mf| (mf.food.fat.to_f * mf.servings).round(1) }
  end

  def nutrition_summary
    {
      calories: total_calories,
      protein: total_protein,
      carbs: total_carbs,
      fat: total_fat
    }
  end
end
