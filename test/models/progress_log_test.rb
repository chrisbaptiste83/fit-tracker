require "test_helper"

class ProgressLogTest < ActiveSupport::TestCase
  # Validations

  test "valid progress log with date" do
    log = users(:one).progress_logs.build(date: Date.current - 10.days, weight: 79.0)
    assert log.valid?
  end

  test "invalid without date" do
    log = users(:one).progress_logs.build(weight: 80.0)
    assert_not log.valid?
    assert_includes log.errors[:date], "can't be blank"
  end

  test "invalid when duplicate date for same user" do
    users(:one).progress_logs.create!(date: 5.days.ago, weight: 80.0)
    duplicate = users(:one).progress_logs.build(date: 5.days.ago, weight: 81.0)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:date], "has already been taken"
  end

  test "same date is allowed for different users" do
    users(:one).progress_logs.create!(date: 3.days.ago, weight: 80.0)
    log = users(:two).progress_logs.build(date: 3.days.ago, weight: 65.0)
    assert log.valid?
  end

  # Scopes

  test "recent scope orders by date descending" do
    logs = users(:one).progress_logs.recent
    dates = logs.map(&:date)
    assert_equal dates.sort.reverse, dates
  end

  test "last_30_days scope returns only logs within 30 days" do
    logs = ProgressLog.last_30_days
    logs.each do |log|
      assert log.date >= 30.days.ago.to_date
    end
  end

  test "last_90_days scope returns only logs within 90 days" do
    logs = ProgressLog.last_90_days
    logs.each do |log|
      assert log.date >= 90.days.ago.to_date
    end
  end

  # weight_trend

  test "weight_trend returns array of date/weight pairs" do
    trend = ProgressLog.weight_trend(users(:one))
    assert_kind_of Array, trend
    trend.each do |pair|
      assert_equal 2, pair.length
    end
  end

  test "weight_trend excludes nil weights" do
    users(:one).progress_logs.create!(date: 4.days.ago)
    trend = ProgressLog.weight_trend(users(:one))
    trend.each do |_date, weight|
      assert_not_nil weight
    end
  end

  test "weight_trend does not return logs from other users" do
    # Create an exclusive date for user :two that user :one has no log for
    exclusive_date = 2.days.ago.to_date
    users(:two).progress_logs.create!(date: exclusive_date, weight: 99.9)
    trend_user_one = ProgressLog.weight_trend(users(:one))
    dates_in_trend = trend_user_one.map { |date, _| date }
    assert_not_includes dates_in_trend, exclusive_date
  end

  # bmi

  test "bmi returns nil when weight is nil" do
    log = users(:one).progress_logs.build(date: 2.days.ago)
    assert_nil log.bmi
  end

  test "bmi returns nil when user height is nil" do
    user = User.create!(email_address: "noheight@example.com", password: "password")
    log = user.progress_logs.build(date: Date.current - 2.days, weight: 80.0)
    assert_nil log.bmi
  end

  test "bmi calculates correctly" do
    log = progress_logs(:log_week1)
    # user one: height=175, weight=81 -> 81 / (1.75^2) = 81 / 3.0625 = 26.4
    expected = (81.0 / (1.75 * 1.75)).round(1)
    assert_in_delta expected, log.bmi, 0.1
  end

  # Association

  test "belongs to user" do
    assert_equal users(:one), progress_logs(:log_week1).user
  end
end
