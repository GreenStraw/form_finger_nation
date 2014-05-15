class CreatePartyInvitations < ActiveRecord::Migration
  def change
    create_table :party_invitations do |t|
      t.belongs_to :user
      t.belongs_to :party
    end

    add_index(:party_invitations, :user_id)
    add_index(:party_invitations, :party_id)
  end
end
