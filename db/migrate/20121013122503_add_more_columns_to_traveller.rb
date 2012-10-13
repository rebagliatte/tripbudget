class AddMoreColumnsToTraveller < ActiveRecord::Migration
  def change
    add_column :travellers, :location, :string, default: ''
    add_column :travellers, :image, :string, default: ''
    add_column :travellers, :description, :string, default: ''
    add_column :travellers, :url, :string, default: ''
    add_column :travellers, :twitter_url, :string, default: ''
  end
end
