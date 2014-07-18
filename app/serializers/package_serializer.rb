class PackageSerializer < ImageSerializer
  attributes :name, :description, :price, :is_public
  has_many :parties, embed: :ids
  has_many :vouchers, embed: :ids
  has_one :venue, embed: :ids
end
