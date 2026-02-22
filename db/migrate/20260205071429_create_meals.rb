class CreateMeals < ActiveRecord::Migration[8.0]
  def change
    create_table :meals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :meal_type
      t.date :date
      t.text :notes

      t.timestamps
    end
  end
end
