class AddWebsiteToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :website, :string
  end
end
