class CreatePartyInvitations < ActiveRecord::Migration
  def change
    create_table :party_invitations do |t|
      t.string :unregistered_invitee_email
      t.string :uuid
      t.belongs_to :inviter
      t.boolean :claimed, :default => false
      t.belongs_to :user
      t.belongs_to :party
    end

    add_index(:party_invitations, :user_id)
    add_index(:party_invitations, :party_id)
    add_index(:party_invitations, :inviter_id)
  end
end
