class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name, null: false, default: ''
      t.text :description, default: ''
      t.boolean :is_public
      t.integer :owner_id, null: false

      t.timestamps
    end
  end
end
