class AddFriendlyUrlToParty < ActiveRecord::Migration
  def change
    add_column :parties, :friendly_url, :string
  end
end
