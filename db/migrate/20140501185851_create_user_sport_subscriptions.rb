class CreateUserSportSubscriptions < ActiveRecord::Migration
  def change
    create_table :user_sport_subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :sport
      t.timestamps
    end

    add_index(:user_sport_subscriptions, :user_id)
    add_index(:user_sport_subscriptions, :sport_id)
  end
end
