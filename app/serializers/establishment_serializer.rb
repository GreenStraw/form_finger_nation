class EstablishmentSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url
  has_one :user
  has_one :address
end
