class AddressSerializer < BaseSerializer
  attributes :id, :street1, :street2, :city, :state, :zip, :addressable_id, :addressable_type, :latitude, :longitude, :created_at, :updated_at

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end
