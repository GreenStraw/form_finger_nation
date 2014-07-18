class AddressSerializer < BaseSerializer
  attributes :street1, :street2, :city, :state, :zip, :addressable_id, :addressable_type, :latitude, :longitude
end
