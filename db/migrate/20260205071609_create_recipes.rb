class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.text :instructions
      t.integer :prep_time
      t.integer :cook_time
      t.integer :servings
      t.integer :calories
      t.decimal :protein
      t.decimal :carbs
      t.decimal :fat
      t.string :image_url
      t.boolean :ai_generated

      t.timestamps
    end
  end
end
