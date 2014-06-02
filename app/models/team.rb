class Team < ActiveRecord::Base
  has_many :favorites, as: :favoritable
  has_many :fans, through: :favorites, source: :favoriter, source_type: "User"
  has_many :team_host_endorsements
  has_many :regional_hosts, through: :team_host_endorsements, source: :user
  belongs_to :sport
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
end
