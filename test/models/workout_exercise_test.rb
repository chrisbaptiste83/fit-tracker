require "test_helper"

class WorkoutExerciseTest < ActiveSupport::TestCase
  test "auto-sets order before validation on create" do
    we = WorkoutExercise.new(
      workout: workouts(:upcoming_workout),
      exercise: exercises(:running)
    )
    assert we.valid?
    assert_not_nil we.order
  end

  test "auto-sets order sequentially after existing exercises" do
    workout = workouts(:upcoming_workout)
    existing_max = workout.workout_exercises.maximum(:order)

    new_we = WorkoutExercise.create!(
      workout: workout,
      exercise: exercises(:running)
    )
    assert_equal existing_max + 1, new_we.order
  end

  test "volume returns sets times reps times weight" do
    we = WorkoutExercise.new(sets: 3, reps: 10, weight: 50.0)
    assert_equal 1500.0, we.volume
  end

  test "volume returns zero for bodyweight exercises with no weight" do
    we = workout_exercises(:push_up_in_workout)
    # sets: 3, reps: 10, weight: 0
    assert_equal 0.0, we.volume
  end

  test "volume handles nil values gracefully" do
    we = WorkoutExercise.new(sets: nil, reps: nil, weight: nil)
    assert_equal 0.0, we.volume
  end
end
