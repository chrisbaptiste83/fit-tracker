class Exercise < ApplicationRecord
  has_many :workout_exercises, dependent: :destroy
  has_many :workouts, through: :workout_exercises

  enum :category, {
    strength: "strength",
    cardio: "cardio",
    flexibility: "flexibility",
    sports: "sports"
  }, prefix: true

  enum :muscle_group, {
    chest: "chest",
    back: "back",
    legs: "legs",
    arms: "arms",
    shoulders: "shoulders",
    core: "core",
    full_body: "full_body"
  }, prefix: true

  enum :difficulty, {
    beginner: "beginner",
    intermediate: "intermediate",
    advanced: "advanced"
  }, prefix: true

  validates :name, presence: true
  validates :category, presence: true
  validates :muscle_group, presence: true
  validates :difficulty, presence: true

  scope :by_category, ->(category) { where(category: category) }
  scope :by_muscle_group, ->(group) { where(muscle_group: group) }
  scope :by_difficulty, ->(level) { where(difficulty: level) }

  def self.search(query)
    where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
  end
end
