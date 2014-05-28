class Team < ActiveRecord::Base
  has_many :user_team_subscriptions
  has_many :fans, through: :user_team_subscriptions, source: :user
  has_many :team_host_endorsements
  has_many :regional_hosts, through: :team_host_endorsements, source: :user
  belongs_to :sport
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
end
