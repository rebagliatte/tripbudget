class AddInvitationUrlToTravellers < ActiveRecord::Migration
  def change
    add_column :travellers, :invitation_url, :string, default:''
  end
end
