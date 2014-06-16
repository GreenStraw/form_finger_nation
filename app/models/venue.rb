class Venue < ActiveRecord::Base
  has_many :comments, as: :commenter
  has_many :parties
  has_many :favorites, as: :favoriter, dependent: :destroy
  has_many :favorite_sports, through: :favorites, source: :favoritable, source_type: "Sport"
  has_many :favorite_teams, through: :favorites, source: :favoritable, source_type: "Team"
  has_many :packages
  has_one :address, as: :addressable, dependent: :destroy
end
