require "test_helper"

class GoalTest < ActiveSupport::TestCase
  def valid_attrs
    {
      user: users(:alice),
      goal_type: :weight,
      target_value: 65.0,
      current_value: 0.0,
      unit: "kg",
      start_date: Date.current,
      target_date: 1.year.from_now.to_date,
      description: "Reach target weight"
    }
  end

  test "requires goal_type" do
    assert_not Goal.new(valid_attrs.except(:goal_type)).valid?
  end

  test "requires target_value" do
    assert_not Goal.new(valid_attrs.except(:target_value)).valid?
  end

  test "requires description" do
    assert_not Goal.new(valid_attrs.except(:description)).valid?
  end

  test "requires start_date" do
    assert_not Goal.new(valid_attrs.except(:start_date)).valid?
  end

  test "requires target_date" do
    assert_not Goal.new(valid_attrs.except(:target_date)).valid?
  end

  test "completed? returns false for an active goal" do
    assert_not goals(:weight_loss).completed?
  end

  test "completed? returns true when completed_at is set" do
    assert goals(:completed_habit).completed?
  end

  test "complete! marks goal as completed and sets current_value to target" do
    goal = goals(:weight_loss)
    goal.complete!
    assert goal.reload.completed?
    assert_equal goal.target_value, goal.current_value
  end

  test "progress_percentage returns 100 for a completed goal" do
    assert_equal 100, goals(:completed_habit).progress_percentage
  end

  test "progress_percentage calculates proportion of current to target" do
    goal = goals(:weight_loss)
    # current_value: 32.5, target_value: 65.0 -> 50%
    assert_equal 50, goal.progress_percentage
  end

  test "progress_percentage is capped at 100" do
    goal = Goal.new(valid_attrs.merge(current_value: 200.0))
    assert_equal 100, goal.progress_percentage
  end

  test "days_remaining calculates days until target_date" do
    goal = goals(:weight_loss)
    expected = (goal.target_date - Date.current).to_i
    assert_equal expected, goal.days_remaining
  end

  test "days_remaining returns 0 for a completed goal" do
    assert_equal 0, goals(:completed_habit).days_remaining
  end

  test "active scope excludes completed goals" do
    assert_includes Goal.active, goals(:weight_loss)
    assert_not_includes Goal.active, goals(:completed_habit)
  end

  test "completed scope includes only completed goals" do
    assert_includes Goal.completed, goals(:completed_habit)
    assert_not_includes Goal.completed, goals(:weight_loss)
  end
end
