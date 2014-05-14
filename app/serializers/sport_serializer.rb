class SportSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url
  has_many :teams, key: :teams, root: :teams, include: true
  has_many :users, key: :users, root: :users
end
