class CreatePartyInvitations < ActiveRecord::Migration
  def change
    create_table :party_invitations do |t|
      t.string :email
      t.string :uuid
      t.string :status, default: 'pending'
      t.belongs_to :inviter
      t.belongs_to :user
      t.belongs_to :party
      t.timestamps
    end

    add_index(:party_invitations, :user_id)
    add_index(:party_invitations, :party_id)
    add_index(:party_invitations, :inviter_id)
  end
end
