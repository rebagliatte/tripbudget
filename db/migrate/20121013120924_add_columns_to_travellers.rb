class AddColumnsToTravellers < ActiveRecord::Migration
  def change
    add_column :travellers, :provider, :string, null: false, default:''
    rename_column :travellers, :twitter_uid, :uid
  end
end
