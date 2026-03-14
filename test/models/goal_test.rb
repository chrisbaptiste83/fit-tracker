require "test_helper"

class GoalTest < ActiveSupport::TestCase
  # Validations

  test "valid goal with all required attributes" do
    goal = users(:one).goals.build(
      goal_type: "weight",
      target_value: 70.0,
      description: "Lose weight",
      start_date: Date.current,
      target_date: 3.months.from_now
    )
    assert goal.valid?
  end

  test "invalid without goal_type" do
    goal = users(:one).goals.build(
      target_value: 70.0, description: "Test",
      start_date: Date.current, target_date: 3.months.from_now
    )
    assert_not goal.valid?
    assert_includes goal.errors[:goal_type], "can't be blank"
  end

  test "invalid without target_value" do
    goal = users(:one).goals.build(
      goal_type: "weight", description: "Test",
      start_date: Date.current, target_date: 3.months.from_now
    )
    assert_not goal.valid?
    assert_includes goal.errors[:target_value], "can't be blank"
  end

  test "invalid without description" do
    goal = users(:one).goals.build(
      goal_type: "weight", target_value: 70.0,
      start_date: Date.current, target_date: 3.months.from_now
    )
    assert_not goal.valid?
    assert_includes goal.errors[:description], "can't be blank"
  end

  test "invalid without start_date" do
    goal = users(:one).goals.build(
      goal_type: "weight", target_value: 70.0,
      description: "Test", target_date: 3.months.from_now
    )
    assert_not goal.valid?
    assert_includes goal.errors[:start_date], "can't be blank"
  end

  test "invalid without target_date" do
    goal = users(:one).goals.build(
      goal_type: "weight", target_value: 70.0,
      description: "Test", start_date: Date.current
    )
    assert_not goal.valid?
    assert_includes goal.errors[:target_date], "can't be blank"
  end

  # Enums

  test "goal_type enum includes expected values" do
    assert_equal %w[weight strength habit nutrition], Goal.goal_types.keys
  end

  test "goal_type predicate methods work" do
    assert goals(:active_weight_goal).goal_type_weight?
    assert_not goals(:active_weight_goal).goal_type_strength?
  end

  # Scopes

  test "active scope returns goals without completed_at" do
    active = Goal.active
    active.each { |g| assert_nil g.completed_at }
    assert_includes active, goals(:active_weight_goal)
  end

  test "completed scope returns goals with completed_at set" do
    completed = Goal.completed
    completed.each { |g| assert g.completed_at.present? }
    assert_includes completed, goals(:completed_strength_goal)
  end

  test "by_type scope filters by goal type" do
    weight_goals = Goal.by_type("weight")
    assert_includes weight_goals, goals(:active_weight_goal)
    assert_not_includes weight_goals, goals(:completed_strength_goal)
  end

  # completed?

  test "completed? returns false when completed_at is nil" do
    assert_not goals(:active_weight_goal).completed?
  end

  test "completed? returns true when completed_at is set" do
    assert goals(:completed_strength_goal).completed?
  end

  # complete!

  test "complete! sets completed_at" do
    goal = goals(:active_weight_goal)
    assert_nil goal.completed_at
    goal.complete!
    assert_not_nil goal.reload.completed_at
  end

  test "complete! sets current_value to target_value" do
    goal = goals(:active_weight_goal)
    goal.complete!
    assert_equal goal.target_value, goal.reload.current_value
  end

  # progress_percentage

  test "progress_percentage returns 100 for completed goal" do
    assert_equal 100, goals(:completed_strength_goal).progress_percentage
  end

  test "progress_percentage returns 0 when target_value is zero" do
    goal = users(:one).goals.build(
      goal_type: "habit", target_value: 0,
      current_value: 0, description: "Test",
      start_date: Date.current, target_date: 1.month.from_now
    )
    assert_equal 0, goal.progress_percentage
  end

  test "progress_percentage calculates correctly" do
    goal = goals(:active_weight_goal) # current=80, target=75
    # percentage = (80/75 * 100) = 106 -> capped at 100
    assert_equal 100, goal.progress_percentage
  end

  test "progress_percentage is capped at 100" do
    goal = users(:one).goals.build(
      goal_type: "strength", target_value: 50.0,
      current_value: 100.0, description: "Test",
      start_date: Date.current, target_date: 1.month.from_now
    )
    assert_equal 100, goal.progress_percentage
  end

  # days_remaining

  test "days_remaining returns 0 for completed goal" do
    assert_equal 0, goals(:completed_strength_goal).days_remaining
  end

  test "days_remaining returns 0 when target_date is in the past" do
    goal = users(:one).goals.build(
      goal_type: "weight", target_value: 70.0,
      description: "Test", start_date: 2.months.ago,
      target_date: 1.month.ago
    )
    assert_equal 0, goal.days_remaining
  end

  test "days_remaining returns positive integer for future goal" do
    goal = goals(:active_weight_goal) # target_date: 2026-06-01
    assert goal.days_remaining > 0
  end

  # on_track?

  test "on_track? returns true for completed goal" do
    assert goals(:completed_strength_goal).on_track?
  end
end
