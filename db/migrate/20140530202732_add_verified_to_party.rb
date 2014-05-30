class AddVerifiedToParty < ActiveRecord::Migration
  def change
    add_column :parties, :verified, :boolean
  end
end
