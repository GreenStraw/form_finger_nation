class Venue < ActiveRecord::Base
  resourcify
  after_create :ensure_address

  has_many :comments, as: :commenter
  has_many :parties
  has_many :favorites, as: :favoriter, dependent: :destroy
  has_many :favorite_sports, through: :favorites, source: :favoritable, source_type: "Sport"
  has_many :favorite_teams, through: :favorites, source: :favoritable, source_type: "Team"
  has_many :packages
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :address

  private

  def ensure_address
    if address.nil?
      create_address
    end
  end
end
