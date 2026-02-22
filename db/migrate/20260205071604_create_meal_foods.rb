class CreateMealFoods < ActiveRecord::Migration[8.0]
  def change
    create_table :meal_foods do |t|
      t.references :meal, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.decimal :servings

      t.timestamps
    end
  end
end
