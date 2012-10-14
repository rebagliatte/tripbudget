class AddIsActiveToTips < ActiveRecord::Migration
  def change
    add_column :trips, :is_active, :boolean, null: false, default: false
  end
end
