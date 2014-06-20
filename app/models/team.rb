class Team < ActiveRecord::Base
  resourcify
  validates :name, presence: true

  has_many :favorites, as: :favoritable
  has_many :fans, through: :favorites, source: :favoriter, source_type: "User"
  has_many :venue_fans, through: :favorites, source: :favoriter, source_type: "Venue"
  has_many :endorsements, as: :endorser
  has_many :endorsed_hosts, through: :endorsements, source: :endorsable, source_type: "User"
  belongs_to :sport
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :address
end
