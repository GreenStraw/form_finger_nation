class Address < ActiveRecord::Base
  geocoded_by :full_or_partial_address
  after_validation :geocode
  validates_presence_of :street1
  validate :zip_or_city_and_state
  reverse_geocoded_by :latitude, :longitude
  acts_as_mappable :default_units   => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  belongs_to :addressable, polymorphic: true

  def zip_or_city_and_state
    if !self.street1.present?
      errors.add(:street1, "can't be blank")
    end

    if !self.zip.present?
      if !self.city.present? || !self.state.present?
        errors.add(:city, "and state must both be included if no zip code is provided")
      end
    end
  end

  def self.get_coords(address)
    return nil if address.nil?
    Geocoder.coordinates(address)
  end

  def self.distance_of_two_locations loc1, loc2
  rad_per_deg = Math::PI/180  # PI / 180
  rkm = 6371                  # Earth radius in kilometers
  rm = rkm * 1000             # Radius in meters

  dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
  dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  rm * c # Delta in meters
end

  def street
    "#{street1} #{street2 if street2}"
  end

  def city_state
    "#{city}, #{state}"
  end

  def full_street_address
    "#{street1} #{street2} #{city}, #{state} #{zip}"
  end

  def street_address
    "#{street1} #{street2}"
  end

  def city_state
    "#{city}, #{state} #{zip}"
  end

  def full_or_partial_address
    if city.present? && state.present?
      "#{street1}, #{city} #{state}"
    else #zip
      "#{street}, #{zip}"
    end
  end

  def self.class_within_radius_of(klass, lat, lng, radius)
    Address.where(addressable_type: klass).within(radius, origin: [lat, lng])
  end

  def self.class_within_radius_of_address(klass, address, radius)
    Address.where(addressable_type: klass).within(radius, :origin => address)
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  addressable_id   :integer
#  addressable_type :string(255)
#  street1          :string(255)
#  street2          :string(255)
#  city             :string(255)
#  state            :string(255)
#  zip              :string(255)
#  latitude         :float
#  longitude        :float
#  created_at       :datetime
#  updated_at       :datetime
#
