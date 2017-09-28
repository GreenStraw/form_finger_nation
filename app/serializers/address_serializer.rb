class AddressSerializer < BaseSerializer
  #TODO CALVIN self.root = false
  attributes :street1, :street2, :city, :state, :zip, :addressable_id, :addressable_type, :latitude, :longitude
end
