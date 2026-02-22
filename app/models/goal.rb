class Goal < ApplicationRecord
  belongs_to :user

  enum :goal_type, {
    weight: "weight",
    strength: "strength",
    habit: "habit",
    nutrition: "nutrition"
  }, prefix: true

  validates :goal_type, presence: true
  validates :target_value, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :target_date, presence: true

  scope :active, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :by_type, ->(type) { where(goal_type: type) }

  def completed?
    completed_at.present?
  end

  def complete!
    update(completed_at: Time.current, current_value: target_value)
  end

  def progress_percentage
    return 100 if completed?
    return 0 if target_value.to_f.zero?

    percentage = ((current_value.to_f / target_value.to_f) * 100).round
    [percentage, 100].min
  end

  def days_remaining
    return 0 if completed? || target_date < Date.current

    (target_date - Date.current).to_i
  end

  def on_track?
    return true if completed?

    expected_progress = (Date.current - start_date).to_f / (target_date - start_date).to_f * 100
    progress_percentage >= expected_progress
  end
end
