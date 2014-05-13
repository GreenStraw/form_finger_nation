class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name, :city, :state, :zip, :email, :admin
  has_many :sports, key: :sports, root: :sports
  has_many :teams, key: :teams, root: :teams
  has_many :establishments, key: :establishments, root: :establishments

  def admin
    object.has_role?(:admin)
  end
end
