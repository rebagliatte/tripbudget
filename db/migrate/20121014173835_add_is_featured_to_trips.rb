class AddIsFeaturedToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :is_featured, :boolean, null: false, default: false
  end
end
