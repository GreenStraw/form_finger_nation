class Address < ActiveRecord::Base
  geocoded_by :full_street_address
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude
  acts_as_mappable :default_units   => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  belongs_to :addressable, polymorphic: true

  def street
    "#{street1} #{street2 if street2}"
  end

  def city_state
    "#{city}, #{state}"
  end

  def full_street_address
    "#{street1} #{street2} #{city}, #{state} #{zip}"
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
