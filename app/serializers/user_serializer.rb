class UserSerializer < BaseSerializer
  attributes :id, :username, :first_name, :last_name, :email, :admin, :confirmed, :created_at, :updated_at, :address
  has_many :sports, key: :favorite_sport_ids, root: :favorite_sport_ids#, include: true
  has_many :teams, key: :favorite_team_ids, root: :favorite_team_ids#, include: true
  has_many :managed_venues, key: :managed_venue_ids, root: :managed_venue_ids
  has_many :managed_teams, key: :managed_team_ids, root: :managed_team_ids
  has_many :reservations, key: :reservation_ids, root: :reservation_ids#, include: true
  has_many :invitations, key: :invitation_ids, root: :invitation_ids#, include: true
  has_many :parties, key: :party_ids, root: :party_ids#, include: true
  has_many :endorsing_teams, key: :endorsing_team_ids, root: :endorsing_team_ids
  has_many :user_purchased_packages, key: :purchased_packages, root: :purchased_packages
  has_many :followees, key: :followee_ids, root: :followee_ids
  has_many :followers, key: :follower_ids, root: :follower_ids
  has_many :vouchers, key: :voucher_ids, root: :voucher_ids

  def address
    {
      id: object.address.try(:id),
      addressable_id: object.address.try(:addressable_id),
      addressable_type: object.address.try(:addressable_type),
      street1: object.address.try(:street1),
      street2: object.address.try(:street2),
      city: object.address.try(:city),
      state: object.address.try(:state),
      zip: object.address.try(:zip),
      latitude: object.address.try(:latitude),
      longitude: object.address.try(:longitude),
      created_at: object.address.try(:created_at).try(:to_i),
      updated_at: object.address.try(:updated_at).try(:to_i)
    }
  end

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
