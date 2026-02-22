class CreateFoods < ActiveRecord::Migration[8.0]
  def change
    create_table :foods do |t|
      t.string :name
      t.string :brand
      t.decimal :serving_size
      t.string :serving_unit
      t.integer :calories
      t.decimal :protein
      t.decimal :carbs
      t.decimal :fat
      t.decimal :fiber
      t.string :barcode

      t.timestamps
    end
  end
end
