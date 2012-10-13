class CreateTravellers < ActiveRecord::Migration
  def change
    create_table :travellers do |t|
      t.string :nickname, null: false, default: ''
      t.string :twitter_uid
      t.string :email, default: ''
      t.string :name, default: ''
      t.string :checksum, default: ''

      t.timestamps
    end
  end
end
