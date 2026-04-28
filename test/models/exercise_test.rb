require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  test "requires name" do
    exercise = Exercise.new(category: :strength, muscle_group: :chest, difficulty: :beginner)
    assert_not exercise.valid?
    assert_includes exercise.errors[:name], "can't be blank"
  end

  test "requires category" do
    exercise = Exercise.new(name: "Test", muscle_group: :chest, difficulty: :beginner)
    assert_not exercise.valid?
    assert_includes exercise.errors[:category], "can't be blank"
  end

  test "requires muscle_group" do
    exercise = Exercise.new(name: "Test", category: :strength, difficulty: :beginner)
    assert_not exercise.valid?
    assert_includes exercise.errors[:muscle_group], "can't be blank"
  end

  test "requires difficulty" do
    exercise = Exercise.new(name: "Test", category: :strength, muscle_group: :chest)
    assert_not exercise.valid?
    assert_includes exercise.errors[:difficulty], "can't be blank"
  end

  test "by_category scope returns matching exercises" do
    results = Exercise.by_category(:cardio)
    assert_includes results, exercises(:running)
    assert_not_includes results, exercises(:push_up)
  end

  test "by_muscle_group scope returns matching exercises" do
    results = Exercise.by_muscle_group(:chest)
    assert_includes results, exercises(:push_up)
    assert_not_includes results, exercises(:running)
  end

  test "by_difficulty scope returns matching exercises" do
    results = Exercise.by_difficulty(:beginner)
    assert_includes results, exercises(:push_up)
    assert_not_includes results, exercises(:running)
  end

  test "search finds exercise by name" do
    results = Exercise.search("Push")
    assert_includes results, exercises(:push_up)
    assert_not_includes results, exercises(:running)
  end

  test "search finds exercise by description" do
    results = Exercise.search("Cardiovascular")
    assert_includes results, exercises(:running)
  end

  test "search is case-insensitive via LIKE" do
    assert_includes Exercise.search("push up"), exercises(:push_up)
    assert_includes Exercise.search("PUSH UP"), exercises(:push_up)
  end
end
