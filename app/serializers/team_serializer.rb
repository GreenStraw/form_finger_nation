class TeamSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url
  has_one :sport, key: :sport, root: :sport
  has_many :users, key: :users, root: :users
end
