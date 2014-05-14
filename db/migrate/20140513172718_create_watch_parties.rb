class CreateWatchParties < ActiveRecord::Migration
  def change
    create_table :watch_parties do |t|
      t.string :name
      t.boolean :private
      t.string :description
      t.datetime :scheduled_for
      t.belongs_to :organizer, class_name: 'User'
      t.belongs_to :team
      t.belongs_to :sport
      t.belongs_to :establishment
      t.timestamps
    end

    add_index(:watch_parties, :team_id)
    add_index(:watch_parties, :sport_id)
    add_index(:watch_parties, :organizer_id)
  end
end
