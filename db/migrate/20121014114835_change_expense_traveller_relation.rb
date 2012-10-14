class ChangeExpenseTravellerRelation < ActiveRecord::Migration
  def change
    rename_table :expenses_travellers, :destinations_travellers
    rename_column :destinations_travellers, :expense_id, :destination_id
  end
end
