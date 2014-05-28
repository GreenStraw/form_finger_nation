class CreateVenueSportSubscriptions < ActiveRecord::Migration
  def change
    create_table :venue_sport_subscriptions do |t|
      t.belongs_to :venue
      t.belongs_to :sport
      t.timestamps
    end

    add_index(:venue_sport_subscriptions, :venue_id)
    add_index(:venue_sport_subscriptions, :sport_id)
  end
end
