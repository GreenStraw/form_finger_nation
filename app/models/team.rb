class Team < ActiveRecord::Base
  has_many :user_team_subscriptions
  has_many :users, through: :user_team_subscriptions
  belongs_to :sport
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
end
