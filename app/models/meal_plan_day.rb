class MealPlanDay < ApplicationRecord
  belongs_to :meal_plan
  belongs_to :breakfast_recipe, class_name: "Recipe", optional: true
  belongs_to :lunch_recipe, class_name: "Recipe", optional: true
  belongs_to :dinner_recipe, class_name: "Recipe", optional: true

  validates :day_of_week, presence: true, inclusion: { in: 0..6 }

  DAY_NAMES = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze

  def day_name
    DAY_NAMES[day_of_week]
  end

  def total_calories
    [breakfast_recipe, lunch_recipe, dinner_recipe].compact.sum(&:calories)
  end

  def recipes
    [breakfast_recipe, lunch_recipe, dinner_recipe].compact
  end
end
