require "test_helper"

class WorkoutExerciseTest < ActiveSupport::TestCase
  # Validations

  test "valid workout exercise with required associations" do
    we = WorkoutExercise.new(
      workout: workouts(:upcoming_workout),
      exercise: exercises(:running),
      sets: 3, reps: 12, order: 1
    )
    assert we.valid?
  end

  test "auto-sets order on create when not provided" do
    we = workouts(:upcoming_workout).workout_exercises.create!(
      exercise: exercises(:running),
      sets: 3, reps: 10
    )
    assert_not_nil we.order
    assert we.order > 0
  end

  test "order auto-increments from existing max" do
    workout = workouts(:completed_workout)
    max_order = workout.workout_exercises.maximum(:order)
    new_we = workout.workout_exercises.create!(
      exercise: exercises(:running),
      sets: 1, reps: 1
    )
    assert_equal max_order + 1, new_we.order
  end

  # volume calculation

  test "volume returns sets * reps * weight" do
    we = workout_exercises(:bench_press_set) # sets=4, reps=8, weight=80.0
    assert_in_delta 4 * 8 * 80.0, we.volume, 0.01
  end

  test "volume returns 0.0 when sets/reps/weight are nil" do
    we = WorkoutExercise.new(sets: nil, reps: nil, weight: nil)
    assert_in_delta 0.0, we.volume, 0.01
  end

  test "volume handles zero weight correctly" do
    we = WorkoutExercise.new(sets: 3, reps: 10, weight: 0)
    assert_in_delta 0.0, we.volume, 0.01
  end

  # Associations

  test "belongs to workout" do
    assert_equal workouts(:completed_workout), workout_exercises(:bench_press_set).workout
  end

  test "belongs to exercise" do
    assert_equal exercises(:bench_press), workout_exercises(:bench_press_set).exercise
  end
end
