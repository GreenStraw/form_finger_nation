class Package < ActiveRecord::Base
  validates_presence_of :venue_id

  has_many :party_packages
  has_many :parties, through: :party_packages
  belongs_to :venue
end
