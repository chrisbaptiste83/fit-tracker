require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  test "requires name" do
    workout = Workout.new(user: users(:alice), scheduled_date: Date.current)
    assert_not workout.valid?
    assert_includes workout.errors[:name], "can't be blank"
  end

  test "requires scheduled_date" do
    workout = Workout.new(user: users(:alice), name: "Leg Day")
    assert_not workout.valid?
    assert_includes workout.errors[:scheduled_date], "can't be blank"
  end

  test "completed? returns false when not yet completed" do
    assert_not workouts(:upcoming_workout).completed?
  end

  test "completed? returns true when completed_at is set" do
    assert workouts(:past_workout).completed?
  end

  test "complete! sets completed_at timestamp" do
    workout = workouts(:upcoming_workout)
    assert_nil workout.completed_at
    workout.complete!
    assert_not_nil workout.reload.completed_at
  end

  test "upcoming scope includes future workouts" do
    assert_includes users(:alice).workouts.upcoming, workouts(:upcoming_workout)
  end

  test "upcoming scope excludes past workouts" do
    assert_not_includes users(:alice).workouts.upcoming, workouts(:past_workout)
  end

  test "past scope includes previous workouts" do
    assert_includes users(:alice).workouts.past, workouts(:past_workout)
  end

  test "past scope excludes future workouts" do
    assert_not_includes users(:alice).workouts.past, workouts(:upcoming_workout)
  end

  test "completed scope returns workouts with completed_at" do
    completed = users(:alice).workouts.completed
    assert_includes completed, workouts(:past_workout)
    assert_not_includes completed, workouts(:upcoming_workout)
  end

  test "pending scope returns workouts without completed_at" do
    pending = users(:alice).workouts.pending
    assert_includes pending, workouts(:upcoming_workout)
    assert_not_includes pending, workouts(:past_workout)
  end

  test "total_duration sums exercise durations in minutes" do
    # push_up_in_workout has duration_seconds: 120 -> 2 minutes
    assert_equal 2, workouts(:upcoming_workout).total_duration
  end
end
