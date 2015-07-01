class AddInviteTypeToParty < ActiveRecord::Migration
  def change
    add_column :parties, :invite_type, :string
  end
end
