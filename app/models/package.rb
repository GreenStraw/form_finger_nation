class Package < ActiveRecord::Base
  validates :name, presence: true

  has_many :party_packages
  has_many :parties, through: :party_packages
  belongs_to :venue
end
