class CreateAlternatives < ActiveRecord::Migration
  def change
    create_table :alternatives do |t|
      t.decimal :cost, null: false, default: 0.0
      t.string :person_gap, null: false, default: 'per_person'
      t.string :time_gap, null: false, default: 'per_day'
      t.integer :expense_id
      t.boolean :is_checked

      t.timestamps
    end
  end
end
