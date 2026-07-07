class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise

  validates :order, presence: true

  # sets/reps/weight/duration_seconds/rest_seconds are all optional — different
  # exercise types populate different subsets (e.g. cardio uses duration_seconds,
  # strength uses sets/reps/weight). When present, they must be sane numbers.
  validates :sets, :reps, :rest_seconds,
            numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :weight, :duration_seconds,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation :set_order, on: :create

  def volume
    (sets.to_i * reps.to_i * weight.to_f).round(1)
  end

  private

  def set_order
    self.order ||= (workout.workout_exercises.maximum(:order) || 0) + 1
  end
end
