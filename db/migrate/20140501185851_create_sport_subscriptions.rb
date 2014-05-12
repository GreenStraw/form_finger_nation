class CreateSportSubscriptions < ActiveRecord::Migration
  def change
    create_table :sport_subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :sport
      t.timestamps
    end
  end
  add_index(:sport_subscriptions, :user_id)
  add_index(:sport_subscriptions, :sport_id)
end
