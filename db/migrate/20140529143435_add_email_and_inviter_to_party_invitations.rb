class AddEmailAndInviterToPartyInvitations < ActiveRecord::Migration
  def change
    change_table :party_invitations do |t|
      t.string :unregistered_invitee_email
      t.belongs_to :inviter
      t.string :uuid
      t.boolean :claimed, :default => false
    end
  end
end
