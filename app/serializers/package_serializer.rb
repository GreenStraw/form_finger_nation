class PackageSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :is_public, :created_at
  has_many :parties, key: :party_ids, root: :party_ids
  has_many :vouchers, key: :voucher_ids, root: :voucher_ids
  has_one :venue, key: :venue_id, root: :venue_id
end
