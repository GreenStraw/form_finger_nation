class RegistrationUserSerializer < ActiveModel::Serializer
  self.root = 'user'
  attributes :id, :username, :first_name, :last_name, :email, :admin, :confirmed, :created_at, :updated_at, :authentication_token
  has_one :address
  has_many :sports
  has_many :teams
  has_many :managed_venues
  has_many :managed_teams
  has_many :reservations
  has_many :invitations
  has_many :parties
  has_many :endorsing_teams
  has_many :user_purchased_packages
  has_many :followees
  has_many :followers
  has_many :vouchers

  def confirmed
    object.confirmed_at.present?
  end

  def admin
    object.has_role?(:admin)
  end

  def managed_teams
    teams = []
    if object.has_role?(:team_admin, :any)
      roles = object.roles.where(:name => 'team_admin', :resource_type=>'Team')
      roles.each do |role|
        teams << Team.find(role.resource_id)
      end
    end
    teams
  end

  def managed_venues
    venues = []
    if object.has_role?(:manager, :any)
      roles = object.roles.where(:name => 'manager', :resource_type=>'Venue')
      roles.each do |role|
        venues << Venue.find(role.resource_id)
      end
    end
    venues
  end

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end
