class ChangeExpenseTravellerRelation < ActiveRecord::Migration
  def change
    rename_table :expenses_travellers, :destinations_travellers
  end
end
