class Sport < ActiveRecord::Base
  has_many :teams
  has_many :user_sport_subscriptions
  has_many :users, through: :user_sport_subscriptions
end
