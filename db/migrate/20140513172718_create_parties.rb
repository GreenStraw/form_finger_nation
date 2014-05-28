class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.boolean :private
      t.string :description
      t.datetime :scheduled_for
      t.belongs_to :organizer, class_name: 'User'
      t.belongs_to :team
      t.belongs_to :sport
      t.belongs_to :venue
      t.timestamps
    end

    add_index(:parties, :team_id)
    add_index(:parties, :sport_id)
    add_index(:parties, :organizer_id)
  end
end
