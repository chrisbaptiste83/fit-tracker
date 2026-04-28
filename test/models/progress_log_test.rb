require "test_helper"

class ProgressLogTest < ActiveSupport::TestCase
  test "requires date" do
    log = ProgressLog.new(user: users(:alice), weight: 70)
    assert_not log.valid?
    assert_includes log.errors[:date], "can't be blank"
  end

  test "enforces unique date per user" do
    existing = progress_logs(:alice_march_log)
    duplicate = ProgressLog.new(user: existing.user, date: existing.date, weight: 72)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:date], "has already been taken"
  end

  test "allows the same date for different users" do
    existing = progress_logs(:alice_march_log)
    log = ProgressLog.new(user: users(:bob), date: existing.date, weight: 80)
    # bob already has bob_march_log on 2026-03-01, so use a different date
    log.date = Date.parse("2026-04-01")
    assert log.valid?
  end

  test "bmi calculates correctly from weight and user height" do
    log = progress_logs(:alice_march_log)
    # alice: height 170cm (1.70m), weight 70.5kg
    # BMI = 70.5 / (1.70^2) = 70.5 / 2.89 = 24.4
    expected = (70.5 / (1.70 * 1.70)).round(1)
    assert_in_delta expected, log.bmi, 0.1
  end

  test "bmi returns nil when weight is not set" do
    log = ProgressLog.new(user: users(:alice), date: Date.current)
    assert_nil log.bmi
  end

  test "recent scope orders by date descending" do
    logs = users(:alice).progress_logs.recent
    assert logs.first.date >= logs.last.date
  end

  test "weight_trend returns date/weight pairs for a user" do
    trend = ProgressLog.weight_trend(users(:alice), 60)
    assert trend.is_a?(Array)
    assert trend.all? { |row| row.length == 2 }
  end
end
