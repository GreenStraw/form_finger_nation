class Team < ActiveRecord::Base
  resourcify
  validates :name, presence: true
  after_create :ensure_address

  has_many :favorites, as: :favoritable
  has_many :fans, through: :favorites, source: :favoriter, source_type: "User"
  has_many :venue_fans, through: :favorites, source: :favoriter, source_type: "Venue"
  has_many :endorsements, as: :endorser
  has_many :hosts, through: :endorsements, source: :endorsable, source_type: "User"
  has_many :endorsement_requests
  has_many :requested_hosts, through: :endorsement_requests, source: :user
  belongs_to :sport
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :address

  private

  def ensure_address
    if address.nil?
      create_address
    end
  end
end
