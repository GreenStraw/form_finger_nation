class UserSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :username, :first_name, :last_name, :email, :admin
  has_many :sports, key: :sports, root: :sports#, include: true
  has_many :teams, key: :teams, root: :teams#, include: true
  has_many :venues, key: :venues, root: :venues#, include: true
  has_many :reservations, key: :reservations, root: :reservations#, include: true
  has_many :invitations, key: :invitations, root: :invitations#, include: true
  has_many :parties, key: :parties, root: :parties#, include: true
  has_many :endorsing_teams, key: :endorsing_teams, root: :endorsing_teams
  has_many :employers, key: :employers, root: :employers
  has_one :address, key: :address, root: :address, include: true

  def admin
    object.has_role?(:admin)
  end

  def employers
    teams = []
    if object.has_role?(:team_admin, :any)
      roles = object.roles.where(:name => 'team_admin', :resource_type=>'Team')
      roles.each do |role|
        teams << Team.find(role.resource_id)
      end
    end
    teams
  end
end
