class PackageSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :description, :price, :is_public
  has_many :parties, key: :party_ids, root: :party_ids
  has_one :venue, key: :venue_id, root: :venue_id
end
