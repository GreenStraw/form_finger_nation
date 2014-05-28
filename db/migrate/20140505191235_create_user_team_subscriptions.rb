class CreateUserTeamSubscriptions < ActiveRecord::Migration
  def change
    create_table :user_team_subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :team
      t.timestamps
    end

    add_index(:user_team_subscriptions, :user_id)
    add_index(:user_team_subscriptions, :team_id)
  end
end


