class AddTravellerTripTable < ActiveRecord::Migration
  def change
    create_table :travellers_trips do |t|
      t.integer :traveller_id
      t.integer :trip_id
    end

    add_index 'travellers_trips', ['traveller_id'], name: 'index_traveller_trips_on_traveller_id'
    add_index 'travellers_trips', ['trip_id'], name: 'index_traveller_trips_on_trip_id'
  end
end
