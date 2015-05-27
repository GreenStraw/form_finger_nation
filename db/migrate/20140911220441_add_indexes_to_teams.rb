class AddIndexesToTeams < ActiveRecord::Migration
  def change
    add_index :teams, :sport_id
    add_index :teams, :name
  end
end
