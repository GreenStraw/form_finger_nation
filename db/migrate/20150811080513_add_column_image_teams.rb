class AddColumnImageTeams < ActiveRecord::Migration
  def change
  	add_column :teams, :banner, :string
  end
end
