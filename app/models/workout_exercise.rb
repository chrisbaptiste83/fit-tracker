class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise

  validates :order, presence: true

  before_validation :set_order, on: :create

  def volume
    (sets.to_i * reps.to_i * weight.to_f).round(1)
  end

  private

  def set_order
    self.order ||= (workout.workout_exercises.maximum(:order) || 0) + 1
  end
end
