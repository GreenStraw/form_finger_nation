class Venue < ActiveRecord::Base
  geocoded_by :full_street_address
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude

  has_many :parties
  belongs_to :user

  def full_street_address
    "#{street1} #{street2} #{city}, #{state} #{zip}"
  end
end
