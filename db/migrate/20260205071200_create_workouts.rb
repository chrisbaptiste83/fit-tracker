class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.date :scheduled_date
      t.datetime :completed_at
      t.integer :duration_minutes
      t.integer :calories_burned
      t.text :notes
      t.boolean :ai_generated

      t.timestamps
    end
  end
end
