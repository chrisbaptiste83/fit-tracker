class Food < ApplicationRecord
  has_many :meal_foods, dependent: :destroy
  has_many :meals, through: :meal_foods

  validates :name, presence: true
  validates :calories, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :serving_size, presence: true

  scope :by_brand, ->(brand) { where(brand: brand) }

  def self.search(query)
    where("name LIKE ? OR brand LIKE ?", "%#{query}%", "%#{query}%")
  end

  def macros_summary
    "P: #{protein.to_f.round(1)}g | C: #{carbs.to_f.round(1)}g | F: #{fat.to_f.round(1)}g"
  end
end
