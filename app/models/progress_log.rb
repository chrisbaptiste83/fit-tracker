class ProgressLog < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :date, presence: true, uniqueness: { scope: :user_id }

  scope :recent, -> { order(date: :desc) }
  scope :last_30_days, -> { where("date >= ?", 30.days.ago) }
  scope :last_90_days, -> { where("date >= ?", 90.days.ago) }

  def self.weight_trend(user, days = 30)
    where(user: user)
      .where("date >= ?", days.days.ago)
      .where.not(weight: nil)
      .order(:date)
      .pluck(:date, :weight)
  end

  def bmi
    return nil unless weight && user.height

    height_m = user.height / 100.0
    (weight / (height_m * height_m)).round(1)
  end
end
