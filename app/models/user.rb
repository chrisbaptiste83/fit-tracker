class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Fitness associations
  has_many :workouts, dependent: :destroy
  has_many :meals, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :meal_plans, dependent: :destroy
  has_many :progress_logs, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :ai_conversations, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Enums for fitness profile
  enum :fitness_goal, {
    lose_weight: "lose_weight",
    build_muscle: "build_muscle",
    maintain: "maintain",
    endurance: "endurance"
  }, prefix: true

  enum :activity_level, {
    sedentary: "sedentary",
    light: "light",
    moderate: "moderate",
    active: "active",
    very_active: "very_active"
  }, prefix: true

  enum :gender, {
    male: "male",
    female: "female",
    other: "other"
  }, prefix: true

  validates :email_address, presence: true, uniqueness: true

  # Password strength policy (A07 compliance)
  validate :password_strength, if: -> { password.present? }

  # Account lockout configuration (A07 compliance)
  MAX_FAILED_ATTEMPTS = 5
  LOCKOUT_DURATION = 30.minutes

  # Calculate BMR using Mifflin-St Jeor equation
  def bmr
    return nil unless weight && height && age && gender

    if gender_male?
      (10 * weight) + (6.25 * height) - (5 * age) + 5
    else
      (10 * weight) + (6.25 * height) - (5 * age) - 161
    end
  end

  # Calculate TDEE based on activity level
  def tdee
    return nil unless bmr && activity_level

    multiplier = case activity_level
    when "sedentary" then 1.2
    when "light" then 1.375
    when "moderate" then 1.55
    when "active" then 1.725
    when "very_active" then 1.9
    else 1.2
    end

    (bmr * multiplier).round
  end

  # Get today's nutrition totals
  def today_nutrition
    today_meals = meals.where(date: Date.current).includes(meal_foods: :food)

    totals = { calories: 0, protein: 0, carbs: 0, fat: 0 }

    today_meals.each do |meal|
      meal.meal_foods.each do |mf|
        totals[:calories] += (mf.food.calories * mf.servings).to_i
        totals[:protein] += (mf.food.protein * mf.servings).to_f
        totals[:carbs] += (mf.food.carbs * mf.servings).to_f
        totals[:fat] += (mf.food.fat * mf.servings).to_f
      end
    end

    totals
  end

  # Get today's workout summary
  def today_workouts
    workouts.where(scheduled_date: Date.current)
  end

  # Account lockout methods (A07 compliance)
  def increment_failed_attempts!
    # Atomic read-modify-write at the DB level. Doing this in Ruby
    # (read failed_attempts, +1, write back) loses increments under
    # concurrent failed logins, letting an attacker slip past the lockout
    # threshold. Let the database serialize the increment instead.
    self.class.where(id: id).update_all(
      "failed_attempts = COALESCE(failed_attempts, 0) + 1, " \
      "locked_at = CASE WHEN COALESCE(failed_attempts, 0) + 1 >= #{MAX_FAILED_ATTEMPTS} " \
      "THEN CURRENT_TIMESTAMP ELSE locked_at END"
    )
    reload
  end

  def lock_access!
    update_column(:locked_at, Time.current)
  end

  def access_locked?
    return false unless locked_at.present?

    if locked_at < LOCKOUT_DURATION.ago
      unlock_access!
      return false
    end

    true
  end

  def unlock_access!
    update_columns(failed_attempts: 0, locked_at: nil)
  end

  def self.authenticate_with_lockout(email_address, password)
    user = find_by(email_address: email_address.to_s.strip.downcase)
    return nil unless user

    if user.access_locked?
      user.errors.add(:base, "Account is temporarily locked due to too many failed attempts. Please try again later.")
      return user
    end

    if user.authenticate(password)
      user.unlock_access! if user.failed_attempts.to_i > 0
      user
    else
      user.increment_failed_attempts!
      nil
    end
  end

  private

  def password_strength
    if password.length < 12
      errors.add(:password, "must be at least 12 characters")
    end
    unless password.match?(/[A-Z]/)
      errors.add(:password, "must include an uppercase letter")
    end
    unless password.match?(/[a-z]/)
      errors.add(:password, "must include a lowercase letter")
    end
    unless password.match?(/\d/)
      errors.add(:password, "must include a number")
    end
    unless password.match?(/[^A-Za-z0-9]/)
      errors.add(:password, "must include a special character")
    end
  end
end
