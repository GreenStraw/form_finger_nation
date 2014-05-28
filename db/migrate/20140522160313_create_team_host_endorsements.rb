class CreateTeamHostEndorsements < ActiveRecord::Migration
  def change
    create_table :team_host_endorsements do |t|
      t.belongs_to :team
      t.belongs_to :user
      t.timestamps
    end

    add_index(:team_host_endorsements, :team_id)
    add_index(:team_host_endorsements, :user_id)
  end
end
