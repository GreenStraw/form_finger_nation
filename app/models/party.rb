class Party < ActiveRecord::Base
  extend FriendlyId
  friendly_id :friendly_url

  mount_uploader :image_url, ImageUploader
  mount_uploader :sponser_image, ImageUploader
  mount_uploader :banner, BannerUploader

  acts_as_commentable
  validates :name, presence: true
  # validates :friendly_url, presence: true
  validates :friendly_url, uniqueness: true
  validates :scheduled_for, presence: true
  validate :venue_exists

  after_update :send_notification_when_verified
  after_create :ensure_address

  has_many :party_reservations, dependent: :destroy
  has_many :attendees, through: :party_reservations, source: :user
  has_many :party_invitations, dependent: :destroy
  has_many :invitees, through: :party_invitations, source: :user
  has_many :party_packages, dependent: :destroy
  has_many :packages, through: :party_packages
  has_many :vouchers, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  belongs_to :team
  belongs_to :sport
  belongs_to :venue

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :venue, :reject_if => :no_new_venue

  attr_accessor :user_ids, :emails

  def self.partiesAssignedToVenue(current_user)
    
    venues = []
    venue_assigned_parties  = []

    if current_user.admin?
      venues =  Venue.all
    else
      venues =  Venue.where(id: current_user.roles.where("name = 'venue_manager' OR  name = 'manager'").map(&:resource_id))
    end

    venues.try(:each) do |venue|
      venue_assigned_parties.concat(venue.parties.map {|party| [party.name, party.id]})
    end

    return venue_assigned_parties
  
  end

  def self.getPartyPackages(venue_id, party_id)

      #party_vouchers
      #(venue_id, party_id)

      venue_packages = Package.where("venue_id = ?", venue_id).where(:for_everyone =>  false)
      party_vouchers = Voucher.where(package_id: venue_packages.map(&:id), party_id: party_id)

      party_packages = [] #array that will be sent with package object
      party_packages_ids = [] #keeping track of existing packages

      party_vouchers.try(:each) do |voucher|

        if !party_packages_ids.include?(voucher.package_id)
          party_packages.concat(venue_packages.where("id = ?", voucher.package_id))
          party_packages_ids.push(voucher.package_id)
        end
     
      end

     return party_packages

     #party_packages = [] #array that will be sent with package object
     #party_packages_ids = [] #keeping track of existing packages

     #party_vouchers.try(:each) do |voucher|

     #   if !party_packages_ids.include?(voucher.package_id)
     #     party_packages.concat(voucher)
     #     party_packages_ids.concat(voucher.package_id)
     #   end
     # end

     # return party_packages
  end


 # def sort_parties_geographically(parties)
 #   parties_location_distance = Hash.new
    
 #   parties.each do |team_party|
      
 #     rvs_party_city = team_party.venue.address.city
      
 #     if parties_location_distance.key?(rvs_party_city)
 #       parties_location_distance[rvs_party_city]+=1
 #     else
 #       parties_location_distance[rvs_party_city] = 1
 #     end

 #   end

 #   user_coor = Geocoder.coordinates(current_user.address.city)

 #   parties_location_distance.each do |key,value|
 #     party_coor = Geocoder.coordinates(key)
 #     parties_location_distance[key] = Address.distance_of_two_locations(user_coor,party_coor)
 #   end

 
 #   sorted_distances = Hash[parties_location_distance.sort_by{ |k,v| v }]

    #cities_list = sorted_distances.keys

 #   return sorted_distances
 # end


  def venue_exists
    venue = Venue.where(id: venue_id)
    if (self.venue.present? && !self.venue.new_record?) && venue.blank?
      errors.add(:venue_id, "must be an existing venue.")
    end
  end

  def no_new_venue(attributes)
    attributes[:name].blank? || attributes[:address_attributes].blank? || attributes[:address_attributes][:zip].blank? || attributes[:address_attributes][:street1].blank? || attributes[:address_attributes][:city].blank? || attributes[:address_attributes][:state].blank?
  end

  def scheduled_for=(value)
    if value.is_a?(String)
      value = value.to_i
    end
    self[:scheduled_for] = Time.at(value).to_datetime
  end

  def completed_purchases
    vouchers.where('transaction_id IS NOT NULL')
  end

  def send_notification_when_verified
    if self.verified_changed? && self.verified?
      PartyMailer.watch_party_verified_email(self).deliver
    end
  end

  def unregistered_attendees
    party_reservations.where(:user => nil).map(&:unregistered_rsvp_email)
  end

  def handle_invites(params, user)
    emails = []
    invalid_emails = []
    warning = ""
    success = ""

    params[:invites].each do |k,v|
      if /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/.match(v)
        emails << v unless emails.include?(v)
      else
        invalid_emails << v
      end
    end
    unless invalid_emails.blank?
      part = "Invites not sent to these invalid emails: " + invalid_emails.map(&:inspect).join(', ')
      warning += part
    end

    unless emails.blank?
      PartyInvitation.send_invitations(emails, user.id, self.id)
      part = "Invites sent to " + emails.map(&:inspect).join(', ')
      success += part
    else
      warning += "No valid emails were included"
    end
    [warning, success]
  end

  def self.search(search_item)
    if search_item.blank?
      parties = Party.where("parties.scheduled_for > ?", DateTime.now.beginning_of_day)
      teams = Team.all
      people = User.all
    else
      search_item = "%" + search_item + "%"
      parties = Party.joins(:organizer, :team, :venue)
        .where(["parties.scheduled_for > ? AND (parties.name ILIKE ? OR parties.description ILIKE ? OR users.email ILIKE ? OR users.username ILIKE ? OR users.first_name ILIKE ? OR users.last_name ILIKE ? OR teams.name ILIKE ? OR teams.information ILIKE ? OR venues.name ILIKE ?)",
               DateTime.now.beginning_of_day, search_item, search_item, search_item, search_item, search_item, search_item, search_item, search_item, search_item])
      teams = Party.joins(:team)
       .where(["teams.name ILIKE ? or teams.information ILIKE ?", search_item, search_item])

      people  =  Party.joins(:organizer)
        .where(["users.email ILIKE ? or users.username ILIKE ? OR users.first_name ILIKE ? OR users.last_name ILIKE ?", search_item, search_item, search_item, search_item])
    end
   [parties, teams, people]
  end

  def self.geo_search(address, radius)
    venue_addresses_in_radius = Address.class_within_radius_of_address('Venue', address, radius)
    venues = venue_addresses_in_radius.map(&:addressable).compact
    @parties = venues.map(&:upcoming_parties).flatten.uniq
  end

  def self.search_by_params(party_params)

    radius = 50 #set the location search radius
    #search scenarios, we can either have a search_item, search_location, or both
    if party_params.blank? || (party_params[:search_item].blank? && party_params[:search_location].blank?)
      @parties, @teams, @people = Party.search("")
    else
      if party_params[:search_item].blank? && !party_params[:search_location].blank?
        #location search only
        puts "---"*80
        puts " only location field present "
        puts "---"*80
        parties = Party.geo_search(party_params[:search_location], radius)
        teams = []
        people = []
      elsif !party_params[:search_item].blank? && party_params[:search_location].blank?
        #search item search only
        parties, teams, people = Party.search(party_params[:search_item])
      else
        #both search
        parties1 = Party.geo_search(party_params[:search_location], radius)
        parties2, @teams, @people = Party.search(party_params[:search_item])
        parties = (parties1 & parties2)
        teams = []
        people = []
      end

      [parties,teams,people,party_params[:search_location]]
    end
  end

  def self.build_markers(parties)
    Gmaps4rails.build_markers(parties) do |party, marker|
      marker.lat party.venue.address.latitude
      marker.lng party.venue.address.longitude
    end
  end

  # def facebook_post
  #   puts "=======Sign in ========\n"*9
  #   puts user.inspect
  #   auths = user.authorizations
  #   facebook_auth = auths.facebook
  #   puts "=======Facebook ========\n"*9
  #   puts facebook_auth.inspect

  #   @graph = Koala::Facebook::API.new(facebook_auth.token)

  #   profile = @graph.get_object("me")
  #   friends = @graph.get_connections("me", "friends")
  #   @graph.put_connections("me", "feed", message: "I am writing on my wall!")
  # end

  def twitter_post
    
  end

  private

  def ensure_address
    if address.nil?
      create_address
    end
  end

end

# == Schema Information
#
# Table name: parties
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  is_private    :boolean          default(FALSE)
#  verified      :boolean          default(FALSE)
#  description   :string(255)
#  scheduled_for :datetime
#  organizer_id  :integer
#  team_id       :integer
#  sport_id      :integer
#  venue_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#
