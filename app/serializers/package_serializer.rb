class PackageSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :description, :price
  has_one :venue, key: :venue_id, root: :venue_id
end
