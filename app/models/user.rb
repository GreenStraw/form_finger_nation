class User < ActiveRecord::Base

  include Concerns::TokenAuthenticatable
  extend Enumerize
  rolify
  
  after_create :ensure_address
  after_create :setCurrentLocation

  mount_uploader :image_url, ImageUploader
  mount_uploader :banner, BannerUploader

  # validate :password_on_create_with_email, only: :create
  validates_presence_of :password_confirmation, only: :create, if: '!password.nil?'
  
  #validates_presence_of :username, :email
  validates_presence_of :email
  
  #validates_uniqueness_of :username
  validates_length_of :username, within: 0..250, too_long: 'is too long', too_short: 'is too short'
  #validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  REQUESTED_ROLES = ['Sports Fan', 'Alumni Group', 'Venue']

  attr_accessor :current_password, :access_token, :current_latitude, :current_longitude

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise  :database_authenticatable,
          :recoverable,
          :rememberable,
          :trackable,
          :lockable,
          :validatable,
          :registerable,
          :omniauthable

  has_many :authorizations

  #removethis_milia_function acts_as_universal_and_determines_account
  
  has_many :comments, as: :commenter
  has_many :favorites, as: :favoriter, dependent: :destroy
  has_many :followed_sports, through: :favorites, source: :favoritable, source_type: "Sport"
  has_many :followed_teams, through: :favorites, source: :favoritable, source_type: "Team"
  has_many :followees, through: :favorites, source: :favoritable, source_type: "User"
  has_many :followers, through: :favorites, source: :favoriter, source_type: "User"
  has_many :endorsements, as: :endorsable
  has_many :endorsing_teams, through: :endorsements, source: :endorser, source_type: "Team"
  has_many :party_reservations
  has_many :reservations, through: :party_reservations, source: :party
  has_many :party_invitations
  has_many :invitations, through: :party_invitations, source: :party
  has_many :parties, foreign_key: 'organizer_id'
  has_many :user_purchased_packages
  has_many :packages, through: :user_purchased_packages
  has_many :vouchers
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :address

  def self.admins
    User.with_role(:admin)
  end

  def confirm!
    self.update_attribute(:confirmed_at, DateTime.now)
  end

  def confirmed?
    self.confirmed_at.present?
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

  def admin?
    self.has_role?(:admin)
  end

  def venues_in_the_area(search_location, radius)
    loc = search_location
    rad = radius || 20
    addresses = Address.near(loc, rad).to_a
    if addresses.any?
      venue_ids =  addresses.select{|a| a.addressable_type=='Venue'}.to_a.map(&:addressable_id)
    end
    return venue_ids || []
  end

  def managed_venues
    if self.admin?
      v = Venue.all
      # pull parties that are recently created and not assigned to venue - paties.venue_id is null
      #v.joins("LEFT OUTER JOIN parties ON parties.venue_id = venues.id").where("(parties.venue_id IS NULL AND parties.who_created_location!='venue_house') OR venues.created_by='admin' ")
      v.where("venues.created_by='admin' ")
    elsif self.has_role?(:venue_manager, :any) || self.has_role?(:manager, :any)
      v = Venue.where(id: self.roles.where("name = 'venue_manager' OR  name = 'manager'").map(&:resource_id))
      #v.joins("LEFT OUTER JOIN parties ON parties.venue_id = venues.id").where("(parties.venue_id IS NULL AND parties.who_created_location='venue_house') OR venues.created_by='admin' ")
      v.where("venues.created_by='admin' ")
    else
      []
    end
  end

  def managed_teams
    if self.admin?
      Team.all
    elsif self.has_role?(:team_admin, :any)
      Team.where(id: self.roles.where(name: 'team_admin').map(&:resource_id))
    else
      []
    end
  end

  def get_createdParties
      if !self.admin? 
        Party.where(organizer_id: self.id, is_cancelled: false).where('scheduled_for >= ?', DateTime.now).order(:scheduled_for)
      else
        []
      end
  end

  #todo test cancelled parties
  def get_cancelledParties
      if self.admin?
        parties = Party.where(is_cancelled: true).where('scheduled_for >= ?', DateTime.now).order(:scheduled_for)
      elsif self.has_role?(:venue_manager, :any) || self.has_role?(:manager, :any)
        parties = Party.where(organizer_id: self.id, is_cancelled: true).where('scheduled_for >= ?', DateTime.now)
        parties.joins(:party_reservations).where("party_reservations.party_id != parties.id").order(:scheduled_for)        
      else
        parties = Party.where(organizer_id: self.id, is_cancelled: true).where('scheduled_for >= ?', DateTime.now)
        parties.joins(:party_reservations).where("party_reservations.party_id != parties.id").order(:scheduled_for)
      end
  end

  #todo test reserved parties
  def get_party_reservations

    if !(self.admin? || self.has_role?(:venue_manager, :any) || self.has_role?(:manager, :any)) 
      parties = Party.where(is_cancelled: false).where('scheduled_for >= ?', DateTime.now)
      parties.joins(:party_reservations).where("party_reservations.user_id =? ", self.id).order(:scheduled_for)
    else
      []
    end
  end

  def get_pending_parties
    
    pending_parties = []

    if self.admin?

      pending_parties =  Party.where("who_created_location = 'customer_venue' AND verified = false AND is_cancelled = false").where('scheduled_for >= ?', DateTime.now).order(:scheduled_for)

      #parties.try(:each) do |party|
      #  pending_parties.concat(party)
      #end

    elsif self.has_role?(:venue_manager, :any) || self.has_role?(:manager, :any)

      venues =  Venue.where(id: self.roles.where("name = 'venue_manager' OR  name = 'manager'").map(&:resource_id))

      venues.try(:each) do |venue|
        pending_parties.concat(venue.parties.where('parties.organizer_id != ? AND parties.verified = ? AND is_cancelled = ?', self.id, false, false).where('parties.scheduled_for >= ?', DateTime.now).order(:scheduled_for) )
      end

    else

      pending_parties =  Party.where("parties.organizer_id = ? AND who_created_location = ? AND verified = ? AND is_cancelled = ?", self.id, 'customer_venue', false, false).where('scheduled_for >= ?', DateTime.now).order(:scheduled_for)

    end

    return pending_parties

  end

  def getVenueAccountInfo(venue_id)
    #role =  Role.where("name =? AND resource_type =? AND resource_id =?", "manager", "Venue", venue_id).first
    user_role = UsersRole.where(role_id: Role.where("name =? AND resource_type =? AND resource_id =?", "manager", "Venue", venue_id).map(&:id))
    user = ""
    if user_role.any?
      user = User.where(id: user_role.first.user_id).first.id
    end

    #user =  User.joins("INNER JOIN users_roles ON user.id = users_roles.user_id")
    #user = role.joins("INNER JOIN users_roles ON roles.id = users_roles.role_id").select("users_roles.*")
    #User.where(id: user.user_id)

    return user

  end


  def get_accepted_parties
    
    pending_parties = []

    if self.admin?

      pending_parties =  Party.where("(who_created_location = 'customer_venue' OR who_created_location = 'venue_venue' OR who_created_location = 'admin_venue') AND verified = true AND is_cancelled = false").where('scheduled_for >= ?', DateTime.now).order(:scheduled_for)

      #parties.try(:each) do |party|
      #  pending_parties.concat(party)
      #end

    elsif self.has_role?(:venue_manager, :any) || self.has_role?(:manager, :any)

      venues =  Venue.where(id: self.roles.where("name = 'venue_manager' OR  name = 'manager'").map(&:resource_id))

      venues.try(:each) do |venue|
        pending_parties.concat(venue.parties.where('parties.organizer_id != ? AND parties.verified = ? AND is_cancelled = ?', self.id, true, false).where('parties.scheduled_for >= ?', DateTime.now).order(:scheduled_for) )
      end

    end

    return pending_parties

  end

  def data
    {
      user_id: self.id,
      auth_token: self.authentication_token,
      auth_email: self.email,
      user_name: "#{self.first_name} #{self.last_name}",
      user_admin: self.has_role?(:admin)
    }
  end

  def apply_omniauth(omni)
    authorizations.build(:provider => omni['provider'],
    :uid => omni['uid'],
    :token => omni['credentials'].token,
    :token_secret => omni['credentials'].secret)
  end

  # def password_required?
  #   (authentications.empty? || !password.blank?) && super
  # end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def self.first_user_by_facebook_id(facebook_access_token)
    fb_user = Koala::Facebook::API.new(facebook_access_token)
    fb_details = fb_user.get_object("me")
    fb_id = fb_details["id"]
    User.where(uid: fb_id).first
  rescue
    nil
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_user)
    return nil if auth.blank?
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user = current_user.nil? ? User.where('email = ?', auth.info.email).first : current_user
      if user.blank?
        # For this need access permission for email,user_about_me and home_town
        user = User.new
        user.password = Devise.friendly_token[0,10]
        user.password_confirmation = user.password
        user.name = auth.info.name
        user.first_name = auth.info.first_name
        user.last_name  = auth.info.last_name
        user.gender     = auth.extra.raw_info.gender
        user.email      = auth.info.email
        parts           = auth.info.name.split(" ")
        user.username   = parts[0][0].downcase + parts[1].downcase rescue auth.info.name
        auth.provider == "twitter" ?  user.save!(:validate => false) :  user.save!
      end
      authorization.username = user.username
      authorization.user_id = user.id
      authorization.save
    end
    authorization.user
    user
  end

  def send_welcome_email
    if self.requested_role == 'Venue'
      UserMailer.venue_email(self).deliver
    elsif self.requested_role == 'Alumni Group'
      UserMailer.alumni_group_email(self).deliver
    else
      UserMailer.welcome_email(self).deliver
    end
  end

  def username_email
    "#{username} (#{email})"
  end

  private

  def ensure_address
    create_address if address.nil?
  end
  
  def setCurrentLocation
    current_longitude = nil
    current_latitude = nil
  end

end

# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  email                        :string(255)      default(""), not null
#  encrypted_password           :string(255)      default(""), not null
#  reset_password_token         :string(255)
#  reset_password_sent_at       :datetime
#  remember_created_at          :datetime
#  sign_in_count                :integer          default(0), not null
#  current_sign_in_at           :datetime
#  last_sign_in_at              :datetime
#  current_sign_in_ip           :string(255)
#  last_sign_in_ip              :string(255)
#  confirmation_token           :string(255)
#  confirmed_at                 :datetime
#  confirmation_sent_at         :datetime
#  unconfirmed_email            :string(255)
#  failed_attempts              :integer          default(0), not null
#  unlock_token                 :string(255)
#  locked_at                    :datetime
#  skip_confirm_change_password :boolean          default(FALSE)
#  authentication_token         :string(255)
#  first_name                   :string(255)
#  last_name                    :string(255)
#  role                         :string(255)
#  username                     :string(255)
#  provider                     :string(255)
#  uid                          :string(255)
#  customer_id                  :string(255)
#  facebook_access_token        :string(255)
#  image_url                    :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  name                         :string(255)
#
