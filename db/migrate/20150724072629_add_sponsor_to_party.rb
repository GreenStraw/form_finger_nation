class AddSponsorToParty < ActiveRecord::Migration
  def change
    add_column :parties, :sponsor, :string
  end
end
