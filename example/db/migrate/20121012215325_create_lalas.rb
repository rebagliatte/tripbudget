class CreateLalas < ActiveRecord::Migration
  def change
    create_table :lalas do |t|

      t.timestamps
    end
  end
end
