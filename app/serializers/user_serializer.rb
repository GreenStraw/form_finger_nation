class UserSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :city, :state, :zip, :email, :admin
  has_many :sports, key: :sports, root: :sports#, include: true
  has_many :teams, key: :teams, root: :teams#, include: true
  has_many :establishments, key: :establishments, root: :establishments#, include: true
  has_many :reservations, key: :reservations, root: :reservations#, include: true
  has_many :invitations, key: :invitations, root: :invitations#, include: true
  has_many :parties, key: :parties, root: :parties

  def admin
    object.has_role?(:admin)
  end
end
