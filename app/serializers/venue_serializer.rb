class VenueSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url, :description
  has_many :parties
  has_one :address, key: :address, root: :address, include: true
  has_one :user, key: :user, root: :user
end
