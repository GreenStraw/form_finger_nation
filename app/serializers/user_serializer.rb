class UserSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :city, :state, :zip, :email, :admin
  has_many :sports, key: :sports, root: :sports#, include: true
  has_many :teams, key: :teams, root: :teams#, include: true
  has_many :venues, key: :venues, root: :venues#, include: true
  has_many :reservations, key: :reservations, root: :reservations#, include: true
  has_many :invitations, key: :invitations, root: :invitations#, include: true
  has_many :parties, key: :parties, root: :parties#, include: true
  has_many :endorsing_teams, key: :endorsing_teams, root: :endorsing_teams
  has_one :employer, key: :employer, root: :employer

  def admin
    object.has_role?(:admin)
  end
end
