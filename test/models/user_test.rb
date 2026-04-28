require "test_helper"

class UserTest < ActiveSupport::TestCase
  # Validations

  test "valid user with required attributes" do
    user = User.new(email_address: "newuser@example.com", password: "password")
    assert user.valid?
  end

  test "invalid without email_address" do
    user = User.new(password: "password")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "invalid with duplicate email_address" do
    User.create!(email_address: "dupe@example.com", password: "password")
    user = User.new(email_address: "dupe@example.com", password: "password")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "normalizes email to lowercase and strips whitespace" do
    user = User.create!(email_address: "  UPPER@EXAMPLE.COM  ", password: "password")
    assert_equal "upper@example.com", user.email_address
  end

  # Associations

  test "has many workouts" do
    assert_respond_to users(:one), :workouts
    assert users(:one).workouts.count >= 1
  end

  test "has many meals" do
    assert_respond_to users(:one), :meals
    assert users(:one).meals.count >= 1
  end

  test "has many goals" do
    assert_respond_to users(:one), :goals
    assert users(:one).goals.count >= 1
  end

  test "has many progress_logs" do
    assert_respond_to users(:one), :progress_logs
    assert users(:one).progress_logs.count >= 1
  end

  test "destroying user cascades to workouts" do
    user = User.create!(email_address: "cascade@example.com", password: "password")
    user.workouts.create!(name: "Test Workout", scheduled_date: Date.current)
    assert_difference "Workout.count", -1 do
      user.destroy
    end
  end

  # Enums

  test "fitness_goal enum includes all expected values" do
    assert_equal %w[lose_weight build_muscle maintain endurance], User.fitness_goals.keys
  end

  test "activity_level enum includes all expected values" do
    assert_equal %w[sedentary light moderate active very_active], User.activity_levels.keys
  end

  test "gender enum includes all expected values" do
    assert_equal %w[male female other], User.genders.keys
  end

  test "fitness_goal predicate methods work" do
    user = users(:one)
    assert user.fitness_goal_build_muscle?
    assert_not user.fitness_goal_lose_weight?
  end

  test "activity_level predicate methods work" do
    user = users(:two)
    assert user.activity_level_active?
    assert_not user.activity_level_sedentary?
  end

  # BMR calculation (Mifflin-St Jeor)

  test "bmr returns nil when weight is missing" do
    user = User.new(height: 175, age: 30, gender: "male")
    assert_nil user.bmr
  end

  test "bmr returns nil when height is missing" do
    user = User.new(weight: 80, age: 30, gender: "male")
    assert_nil user.bmr
  end

  test "bmr returns nil when age is missing" do
    user = User.new(weight: 80, height: 175, gender: "male")
    assert_nil user.bmr
  end

  test "bmr returns nil when gender is missing" do
    user = User.new(weight: 80, height: 175, age: 30)
    assert_nil user.bmr
  end

  test "bmr calculates correctly for male" do
    # (10 * 80) + (6.25 * 175) - (5 * 30) + 5 = 1748.75
    user = users(:one)
    assert_in_delta 1748.75, user.bmr, 0.01
  end

  test "bmr calculates correctly for female" do
    # (10 * 65) + (6.25 * 165) - (5 * 28) - 161 = 1380.25
    user = users(:two)
    assert_in_delta 1380.25, user.bmr, 0.01
  end

  # TDEE calculation

  test "tdee returns nil when bmr is nil" do
    assert_nil User.new.tdee
  end

  test "tdee uses 1.55 multiplier for moderate activity" do
    user = users(:one) # moderate
    expected = (user.bmr * 1.55).round
    assert_equal expected, user.tdee
  end

  test "tdee uses 1.725 multiplier for active" do
    user = users(:two) # active
    expected = (user.bmr * 1.725).round
    assert_equal expected, user.tdee
  end

  # today_nutrition

  test "today_nutrition returns zero hash for user with no meals today" do
    user = User.create!(email_address: "empty@example.com", password: "password")
    nutrition = user.today_nutrition
    assert_equal({ calories: 0, protein: 0, carbs: 0, fat: 0 }, nutrition)
  end

  test "today_nutrition returns hash with all macro keys" do
    user = users(:one)
    nutrition = user.today_nutrition
    assert nutrition.key?(:calories)
    assert nutrition.key?(:protein)
    assert nutrition.key?(:carbs)
    assert nutrition.key?(:fat)
  end

  # today_workouts

  test "today_workouts returns an ActiveRecord::Relation" do
    assert_kind_of ActiveRecord::Relation, users(:one).today_workouts
  end

  test "today_workouts scopes to current date" do
    user = users(:one)
    workout = user.workouts.create!(name: "Today Workout", scheduled_date: Date.current)
    assert_includes user.today_workouts, workout
  end
end
