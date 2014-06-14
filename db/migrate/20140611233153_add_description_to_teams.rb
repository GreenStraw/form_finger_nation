class AddDescriptionToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :information, :text
  end
end
