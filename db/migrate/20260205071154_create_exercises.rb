class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
      t.string :name
      t.text :description
      t.string :category
      t.string :muscle_group
      t.string :equipment_needed
      t.string :difficulty
      t.decimal :calories_per_minute
      t.text :instructions

      t.timestamps
    end
  end
end
