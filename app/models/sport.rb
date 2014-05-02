class Sport < ActiveRecord::Base

  has_many :sport_subscriptions
  has_many :users, through: :sport_subscriptions
end
