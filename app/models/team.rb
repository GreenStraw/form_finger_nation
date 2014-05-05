class Team < ActiveRecord::Base

  has_many :team_subscriptions
  has_many :users, through: :team_subscriptions
end
