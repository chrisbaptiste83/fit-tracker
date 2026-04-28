require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  # Validations

  test "valid exercise with all required attributes" do
    exercise = Exercise.new(
      name: "Pull Up", category: "strength",
      muscle_group: "back", difficulty: "intermediate"
    )
    assert exercise.valid?
  end

  test "invalid without name" do
    exercise = Exercise.new(category: "strength", muscle_group: "back", difficulty: "beginner")
    assert_not exercise.valid?
    assert_includes exercise.errors[:name], "can't be blank"
  end

  test "invalid without category" do
    exercise = Exercise.new(name: "Test", muscle_group: "back", difficulty: "beginner")
    assert_not exercise.valid?
    assert_includes exercise.errors[:category], "can't be blank"
  end

  test "invalid without muscle_group" do
    exercise = Exercise.new(name: "Test", category: "strength", difficulty: "beginner")
    assert_not exercise.valid?
    assert_includes exercise.errors[:muscle_group], "can't be blank"
  end

  test "invalid without difficulty" do
    exercise = Exercise.new(name: "Test", category: "strength", muscle_group: "back")
    assert_not exercise.valid?
    assert_includes exercise.errors[:difficulty], "can't be blank"
  end

  # Enums

  test "category enum includes expected values" do
    assert_equal %w[strength cardio flexibility sports], Exercise.categories.keys
  end

  test "muscle_group enum includes expected values" do
    expected = %w[chest back legs arms shoulders core full_body]
    assert_equal expected, Exercise.muscle_groups.keys
  end

  test "difficulty enum includes expected values" do
    assert_equal %w[beginner intermediate advanced], Exercise.difficulties.keys
  end

  test "category predicate methods work" do
    assert exercises(:bench_press).category_strength?
    assert_not exercises(:bench_press).category_cardio?
  end

  test "muscle_group predicate methods work" do
    assert exercises(:bench_press).muscle_group_chest?
    assert exercises(:running).muscle_group_full_body?
  end

  test "difficulty predicate methods work" do
    assert exercises(:bench_press).difficulty_intermediate?
    assert exercises(:running).difficulty_beginner?
  end

  # Scopes

  test "by_category scope filters correctly" do
    results = Exercise.by_category("cardio")
    assert_includes results, exercises(:running)
    assert_not_includes results, exercises(:bench_press)
  end

  test "by_muscle_group scope filters correctly" do
    results = Exercise.by_muscle_group("chest")
    assert_includes results, exercises(:bench_press)
    assert_not_includes results, exercises(:running)
  end

  test "by_difficulty scope filters correctly" do
    results = Exercise.by_difficulty("beginner")
    assert_includes results, exercises(:running)
    assert_not_includes results, exercises(:bench_press)
  end

  # Search

  test "search finds exercises by name" do
    results = Exercise.search("Bench")
    assert_includes results, exercises(:bench_press)
    assert_not_includes results, exercises(:running)
  end

  test "search finds exercises by description" do
    results = Exercise.search("chest press")
    assert_includes results, exercises(:bench_press)
  end

  test "search returns all when query matches multiple" do
    results = Exercise.search("exercise")
    assert results.count >= 1
  end

  test "search is case-insensitive" do
    results = Exercise.search("bench")
    assert_includes results, exercises(:bench_press)
  end
end
