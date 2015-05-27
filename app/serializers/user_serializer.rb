class UserSerializer < ImageSerializer
  attributes :username, :first_name, :last_name, :email, :admin, :confirmed, :requested_role
  has_one :address
  has_many :followed_sports, embed: :ids
  has_many :followed_teams, embed: :ids
  has_many :managed_venues, embed: :ids
  has_many :managed_teams, embed: :ids
  has_many :reservations, embed: :ids
  has_many :invitations, embed: :ids
  has_many :parties, embed: :ids
  has_many :endorsing_teams, embed: :ids
  has_many :user_purchased_packages, embed: :ids
  has_many :followees, embed: :ids
  has_many :followers, embed: :ids
  has_many :vouchers, embed: :ids

  private

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
end
