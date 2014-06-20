class Address < ActiveRecord::Base
  geocoded_by :full_street_address
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude
  validate :city_state_or_zip_present

  belongs_to :addressable, polymorphic: true

  def city_state_or_zip_present
    unless (city.present? && state.present?) || zip.present?
      errors[:base] << 'Address must have a city and state or a zip'
    end
  end

  def full_street_address
    "#{street1} #{street2} #{city}, #{state} #{zip}"
  end
end
