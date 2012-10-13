class AddExpenseTravellerTable < ActiveRecord::Migration
  def change
    create_table :expenses_travellers do |t|
      t.integer :traveller_id
      t.integer :expense_id
    end

    add_index 'expenses_travellers', ['traveller_id'], name: 'index_expenses_travellers_on_traveller_id'
    add_index 'expenses_travellers', ['expense_id'], name: 'index_expenses_travellers_on_expense_id'
  end
end
