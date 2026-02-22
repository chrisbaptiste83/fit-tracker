class Recipe < ApplicationRecord
  belongs_to :user

  has_many :breakfast_meal_plan_days, class_name: "MealPlanDay", foreign_key: "breakfast_recipe_id", dependent: :nullify
  has_many :lunch_meal_plan_days, class_name: "MealPlanDay", foreign_key: "lunch_recipe_id", dependent: :nullify
  has_many :dinner_meal_plan_days, class_name: "MealPlanDay", foreign_key: "dinner_recipe_id", dependent: :nullify

  validates :name, presence: true
  validates :instructions, presence: true
  validates :servings, numericality: { greater_than: 0 }, allow_nil: true

  scope :ai_generated, -> { where(ai_generated: true) }
  scope :user_created, -> { where(ai_generated: false) }

  def total_time
    (prep_time.to_i + cook_time.to_i)
  end

  def macros_summary
    "P: #{protein.to_f.round(1)}g | C: #{carbs.to_f.round(1)}g | F: #{fat.to_f.round(1)}g"
  end

  def self.search(query)
    where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
  end
end
