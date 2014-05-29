class AddressSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :street1, :street2, :city, :state, :zip, :addressable_id, :addressable_type, :latitude, :longitude
end
