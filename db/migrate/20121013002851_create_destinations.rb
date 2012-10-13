class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string :name, null: false, default: ''
      t.string :google_address, default: ''
      t.date :from_date
      t.date :to_date
      t.integer :trip_id

      t.timestamps
    end
  end
end
