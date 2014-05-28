class CreateVenueTeamSubscriptions < ActiveRecord::Migration
  def change
    create_table :venue_team_subscriptions do |t|
      t.belongs_to :venue
      t.belongs_to :team
      t.timestamps
    end

    add_index(:venue_team_subscriptions, :venue_id)
    add_index(:venue_team_subscriptions, :team_id)
  end
end
