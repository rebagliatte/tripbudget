class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body, default: ''
      t.integer :expense_id, null: false
      t.integer :traveller_id, null: false

      t.timestamps
    end
  end
end
