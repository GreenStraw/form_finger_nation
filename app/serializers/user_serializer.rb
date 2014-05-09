class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name, :city, :state, :zip, :email, :admin
  has_many :sports, key: :sports, root: :sports
  has_many :teams, key: :teams, root: :teams
end
