class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :name, null: false, default: ''
      t.string :category, default: ''
      t.integer :destination_id, null: false

      t.timestamps
    end
  end
end
