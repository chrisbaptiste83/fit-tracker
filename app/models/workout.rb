class Workout < ApplicationRecord
  belongs_to :user
  has_many :workout_exercises, -> { order(:order) }, dependent: :destroy
  has_many :exercises, through: :workout_exercises

  validates :name, presence: true
  validates :scheduled_date, presence: true

  scope :upcoming, -> { where("scheduled_date >= ?", Date.current).order(:scheduled_date) }
  scope :past, -> { where("scheduled_date < ?", Date.current).order(scheduled_date: :desc) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :pending, -> { where(completed_at: nil) }
  scope :ai_generated, -> { where(ai_generated: true) }
  scope :this_week, -> { where(scheduled_date: Date.current.beginning_of_week..Date.current.end_of_week) }

  def completed?
    completed_at.present?
  end

  def complete!
    update(completed_at: Time.current)
  end

  def total_duration
    workout_exercises.sum(:duration_seconds) / 60
  end

  def estimated_calories
    workout_exercises.includes(:exercise).sum do |we|
      (we.exercise.calories_per_minute || 5) * (we.duration_seconds.to_i / 60)
    end
  end
end
