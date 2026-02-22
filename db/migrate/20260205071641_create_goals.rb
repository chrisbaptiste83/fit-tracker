class CreateGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :goal_type
      t.decimal :target_value
      t.decimal :current_value
      t.string :unit
      t.date :start_date
      t.date :target_date
      t.datetime :completed_at
      t.text :description

      t.timestamps
    end
  end
end
