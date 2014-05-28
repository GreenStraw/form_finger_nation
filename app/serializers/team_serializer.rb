class TeamSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url
  has_one :sport, key: :sport, root: :sport
  has_one :admin, key: :admin, root: :admin
  has_many :fans, key: :fans, root: :fans
  has_many :regional_hosts, key: :regional_hosts, root: :regional_hosts
end
