class CreateMealPlanDays < ActiveRecord::Migration[8.0]
  def change
    create_table :meal_plan_days do |t|
      t.references :meal_plan, null: false, foreign_key: true
      t.integer :day_of_week
      t.references :breakfast_recipe, foreign_key: { to_table: :recipes }
      t.references :lunch_recipe, foreign_key: { to_table: :recipes }
      t.references :dinner_recipe, foreign_key: { to_table: :recipes }
      t.text :snacks

      t.timestamps
    end
  end
end
