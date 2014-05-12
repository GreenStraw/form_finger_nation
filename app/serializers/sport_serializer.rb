class SportSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name, :image_url
  has_many :teams, key: :teams, root: :teams
  has_many :users, key: :users, root: :users
end
