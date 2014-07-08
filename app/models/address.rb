class Address < ActiveRecord::Base
  geocoded_by :full_street_address
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude

  belongs_to :addressable, polymorphic: true

  def full_street_address
    "#{street1} #{street2} #{city}, #{state} #{zip}"
  end
end
