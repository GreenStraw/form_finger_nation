class UserSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :username, :first_name, :last_name, :email, :admin, :confirmed, :address
  has_many :sports, key: :favorite_sport_ids, root: :favorite_sport_ids#, include: true
  has_many :teams, key: :favorite_team_ids, root: :favorite_team_ids#, include: true
  has_many :managed_venues, key: :managed_venue_ids, root: :managed_venue_ids
  has_many :reservations, key: :reservation_ids, root: :reservation_ids#, include: true
  has_many :invitations, key: :invitation_ids, root: :invitation_ids#, include: true
  has_many :parties, key: :party_ids, root: :party_ids#, include: true
  has_many :endorsing_teams, key: :endorsing_team_ids, root: :endorsing_team_ids
  has_many :employers, key: :employer_ids, root: :employer_ids
  has_many :user_purchased_packages, key: :purchased_packages, root: :purchased_packages
  has_many :followees, key: :followee_ids, root: :followee_ids
  has_many :followers, key: :follower_ids, root: :follower_ids

  def address
    object.address
  end

  def confirmed
    object.confirmed_at.present?
  end

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
end
