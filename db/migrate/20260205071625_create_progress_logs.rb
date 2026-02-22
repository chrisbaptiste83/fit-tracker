class CreateProgressLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :progress_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.decimal :weight
      t.decimal :body_fat_percentage
      t.decimal :chest
      t.decimal :waist
      t.decimal :hips
      t.decimal :arms
      t.decimal :thighs
      t.text :notes

      t.timestamps
    end
  end
end
