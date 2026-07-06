class AddMissingIndexesAndWorkoutExerciseOrderUniqueness < ActiveRecord::Migration[8.0]
  def change
    add_index :meals, :date unless index_exists?(:meals, :date)
    add_index :goals, :goal_type unless index_exists?(:goals, :goal_type)
    add_index :workout_exercises, [:workout_id, :order], unique: true,
              name: 'index_workout_exercises_on_workout_id_and_order' unless index_exists?(:workout_exercises, [:workout_id, :order])
  end
end
