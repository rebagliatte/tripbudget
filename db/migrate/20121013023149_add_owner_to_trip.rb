class AddOwnerToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :owner_id, :integer
  end
end
