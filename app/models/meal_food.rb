class MealFood < ApplicationRecord
  belongs_to :meal
  belongs_to :food

  validates :servings, presence: true, numericality: { greater_than: 0 }

  def calories
    (food.calories * servings).to_i
  end

  def protein
    (food.protein.to_f * servings).round(1)
  end

  def carbs
    (food.carbs.to_f * servings).round(1)
  end

  def fat
    (food.fat.to_f * servings).round(1)
  end
end
