class AddProviderToAlternatives < ActiveRecord::Migration
  def change
    add_column :alternatives, :provider, :string, null: false, default: ''
  end
end
