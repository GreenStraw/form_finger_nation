class AddTwitterDataToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :twitter_widget_id, :string
    add_column :teams, :twitter_name, :string
  end
end
