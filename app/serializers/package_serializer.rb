class PackageSerializer < BaseSerializer
  attributes :name, :description, :price, :is_public, :image_url
  has_many :parties, embed: :ids
  has_many :vouchers, embed: :ids
  has_one :venue, embed: :ids
end
