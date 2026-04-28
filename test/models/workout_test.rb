require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  # Validations

  test "valid workout with name and scheduled_date" do
    workout = users(:one).workouts.build(name: "Test Workout", scheduled_date: Date.current)
    assert workout.valid?
  end

  test "invalid without name" do
    workout = users(:one).workouts.build(scheduled_date: Date.current)
    assert_not workout.valid?
    assert_includes workout.errors[:name], "can't be blank"
  end

  test "invalid without scheduled_date" do
    workout = users(:one).workouts.build(name: "Test")
    assert_not workout.valid?
    assert_includes workout.errors[:scheduled_date], "can't be blank"
  end

  # Scopes

  test "upcoming scope returns workouts on or after today" do
    upcoming = users(:one).workouts.upcoming
    upcoming.each do |w|
      assert w.scheduled_date >= Date.current
    end
  end

  test "past scope returns workouts before today" do
    past = users(:one).workouts.past
    past.each do |w|
      assert w.scheduled_date < Date.current
    end
  end

  test "completed scope returns workouts with completed_at set" do
    completed = Workout.completed
    completed.each { |w| assert w.completed_at.present? }
  end

  test "pending scope returns workouts without completed_at" do
    pending = Workout.pending
    pending.each { |w| assert_nil w.completed_at }
  end

  test "ai_generated scope returns only ai generated workouts" do
    workout = users(:one).workouts.create!(
      name: "AI Workout", scheduled_date: Date.current, ai_generated: true
    )
    assert_includes Workout.ai_generated, workout
    assert_not_includes Workout.ai_generated, workouts(:upcoming_workout)
  end

  test "this_week scope returns workouts within the current week" do
    this_week = Workout.this_week
    this_week.each do |w|
      assert w.scheduled_date >= Date.current.beginning_of_week
      assert w.scheduled_date <= Date.current.end_of_week
    end
  end

  # Instance methods

  test "completed? returns false when completed_at is nil" do
    assert_not workouts(:upcoming_workout).completed?
  end

  test "completed? returns true when completed_at is set" do
    assert workouts(:completed_workout).completed?
  end

  test "complete! sets completed_at" do
    workout = workouts(:upcoming_workout)
    assert_nil workout.completed_at
    workout.complete!
    assert_not_nil workout.reload.completed_at
  end

  test "complete! sets completed_at to current time" do
    workout = workouts(:upcoming_workout)
    freeze_time = Time.current
    travel_to(freeze_time) { workout.complete! }
    assert_in_delta freeze_time.to_i, workout.reload.completed_at.to_i, 1
  end

  test "total_duration returns sum of exercise durations in minutes" do
    workout = workouts(:completed_workout)
    # bench_press_set: 180s + squat_set: 150s = 330s / 60 = 5
    assert_equal 5, workout.total_duration
  end

  test "estimated_calories sums calories across exercises" do
    workout = workouts(:completed_workout)
    result = workout.estimated_calories
    assert result >= 0
    assert_kind_of Numeric, result
  end

  # Associations

  test "belongs to user" do
    assert_equal users(:one), workouts(:upcoming_workout).user
  end

  test "has many workout_exercises" do
    assert workouts(:completed_workout).workout_exercises.count == 2
  end

  test "has many exercises through workout_exercises" do
    assert workouts(:completed_workout).exercises.include?(exercises(:bench_press))
  end

  test "destroying workout cascades to workout_exercises" do
    workout = workouts(:upcoming_workout)
    workout.workout_exercises.create!(
      exercise: exercises(:running),
      sets: 1, reps: 1, order: 1
    )
    assert_difference "WorkoutExercise.count", -1 do
      workout.destroy
    end
  end
end
