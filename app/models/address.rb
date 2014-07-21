class Address < ActiveRecord::Base
  geocoded_by :full_street_address
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude
  acts_as_mappable :default_units   => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  belongs_to :addressable, polymorphic: true

  def full_street_address
    "#{street1} #{street2} #{city}, #{state} #{zip}"
  end

  def self.class_within_radius_of(klass, lat, lng, radius)
    Address.where(addressable_type: klass).within(radius, origin: [lat, lng])
  end
end
