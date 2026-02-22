class CreateMealPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :meal_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.date :week_start_date
      t.boolean :ai_generated
      t.text :notes

      t.timestamps
    end
  end
end
