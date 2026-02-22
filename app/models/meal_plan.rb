class MealPlan < ApplicationRecord
  belongs_to :user
  has_many :meal_plan_days, -> { order(:day_of_week) }, dependent: :destroy

  accepts_nested_attributes_for :meal_plan_days, allow_destroy: true

  validates :week_start_date, presence: true

  scope :ai_generated, -> { where(ai_generated: true) }
  scope :current_week, -> { where(week_start_date: Date.current.beginning_of_week) }
  scope :upcoming, -> { where("week_start_date >= ?", Date.current.beginning_of_week).order(:week_start_date) }

  def week_end_date
    week_start_date + 6.days
  end

  def date_range
    "#{week_start_date.strftime('%b %d')} - #{week_end_date.strftime('%b %d, %Y')}"
  end

  def build_days
    (0..6).each do |day|
      meal_plan_days.build(day_of_week: day) unless meal_plan_days.any? { |d| d.day_of_week == day }
    end
  end
end
