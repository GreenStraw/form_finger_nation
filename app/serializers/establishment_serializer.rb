class EstablishmentSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url, :description, :street1, :street2, :city, :state, :zip, :latitude, :longitude
  has_many :parties
  has_one :user, key: :user, root: :user
end
