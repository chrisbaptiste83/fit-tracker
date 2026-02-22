class AddProfileToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :height, :decimal
    add_column :users, :weight, :decimal
    add_column :users, :age, :integer
    add_column :users, :gender, :string
    add_column :users, :fitness_goal, :string
    add_column :users, :activity_level, :string
    add_column :users, :daily_calorie_goal, :integer
    add_column :users, :protein_goal, :integer
    add_column :users, :carb_goal, :integer
    add_column :users, :fat_goal, :integer
  end
end
