class AddLinkToAlternatives < ActiveRecord::Migration
  def change
    change_table :alternatives do |t|
      t.string :link, null: false, default: ''
    end
  end
end
