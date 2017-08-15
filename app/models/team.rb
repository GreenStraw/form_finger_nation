class Team < ActiveRecord::Base
  resourcify
  validates_presence_of :name
  validates_presence_of :sport_id
  validates_presence_of :page_name
  after_create :ensure_address
  mount_uploader :image_url, TeamImageUploader
  skip_callback :commit, :after, :remove_image_url!
  mount_uploader :banner, BannerUploader
  mount_uploader :team_icon, TeamIconUploader

  has_many :favorites, as: :favoritable
  has_many :fans, through: :favorites, source: :favoriter, source_type: "User"
  has_many :venue_fans, through: :favorites, source: :favoriter, source_type: "Venue"
  has_many :endorsements, as: :endorser
  has_many :hosts, through: :endorsements, source: :endorsable, source_type: "User"
  has_many :endorsement_requests
  has_many :requested_hosts, through: :endorsement_requests, source: :user
  belongs_to :sport
  has_one :address, as: :addressable, dependent: :destroy
  has_many :parties
  accepts_nested_attributes_for :address

  #before_validation :find_by_param
  
  #def to_param
  #  page_name
  #end
  
  #def find_by_param
  #  self.page_name ||= page_name.parameterize.downcase
  #end
  
  def self.ordered_teams(teams)
    grouped_teams = teams.group_by{|t| t.sport.name}
    sport_names_with_teams = Sport.ordered_sports
    ordered_teams = {}
    sport_names_with_teams.each do |sport_name, teams|
      ordered_teams[sport_name] = teams.order(:name)
    end
    ordered_teams
  end

  def admins
    User.with_role(:team_admin, self) || []
  end

  def upcoming_parties
    self.parties.where('scheduled_for >= ?', DateTime.now.new_offset('-05:00')).order(:scheduled_for)
  end

  def self.team_upcoming_parties(ip_zipcode, database_zipcode)

    localParties = []
    
    team_parties = self.parties.where('scheduled_for >= ?', DateTime.now.new_offset('-05:00')).order(:scheduled_for)
    
    team_parties.try(:each) do |party|

      if party.venue.address.zip == database_zipcode || party.venue.address.zip == ip_zipcode

        localParties.concat(party)

      end

    end

    return localParties

  end

  def self.geo_search(lon, lat, radius, team_id)


    parties = Party.where(team_id: team_id)
    team_parties_in_area = []

    if parties.any?

      rad = radius || 50
      lat = 40.71
      lon = -100.23
      addresses = Address.class_within_radius_of('Venue', lat, lon, radius)
      
      #if addresses.any?
      #  venue_ids =  addresses.select{|a| a.addressable_type=='Venue'}.to_a.map(&:addressable_id)

      #  parties.try(:each) do |party|

      #    if venue_ids.include?(party.venue.id)
      #      team_parties_in_area.concat(party)
      #    end

      #  end

      # end

    end
    
    return addresses || []
    #venues = venue_addresses_in_radius.map(&:addressable).compact
    #@parties = venues.map(&:upcoming_parties).flatten.uniq
  end

  private

  def ensure_address
    if address.nil?
      create_address
    end
  end

  def set_default_image_url
    self.image_url = self.sport.image_url
  end


end

# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_url   :string(255)
#  information :text
#  college     :boolean          default(FALSE)
#  sport_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  banner      :string(255)
#  page_name   :string(255)
