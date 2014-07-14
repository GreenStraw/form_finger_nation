class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :first_name, :last_name, :email, :admin, :confirmed, :created_at, :updated_at
  has_one :address
  has_many :sports, key: :favorite_sport_ids, root: :favorite_sport_ids, embed: :ids
  has_many :teams, key: :favorite_team_ids, root: :favorite_team_ids, embed: :ids
  has_many :managed_venues, key: :managed_venue_ids, root: :managed_venue_ids, embed: :ids
  has_many :managed_teams, key: :managed_team_ids, root: :managed_team_ids, embed: :ids
  has_many :reservations, key: :reservation_ids, root: :reservation_ids, embed: :ids
  has_many :invitations, key: :invitation_ids, root: :invitation_ids, embed: :ids
  has_many :parties, key: :party_ids, root: :party_ids, embed: :ids
  has_many :endorsing_teams, key: :endorsing_team_ids, root: :endorsing_team_ids, embed: :ids
  has_many :user_purchased_packages, key: :purchased_packages, root: :purchased_packages, embed: :ids
  has_many :followees, key: :followee_ids, root: :followee_ids, embed: :ids
  has_many :followers, key: :follower_ids, root: :follower_ids, embed: :ids
  has_many :vouchers, key: :voucher_ids, root: :voucher_ids, embed: :ids

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
