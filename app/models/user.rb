class User < ActiveRecord::Base
  include Concerns::TokenAuthenticatable
  extend Enumerize
  rolify
  after_create :ensure_address
  
  EMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # validate :password_on_create_with_email, only: :create
  validates_presence_of :password_confirmation, only: :create, if: '!password.nil?'
  validates_presence_of :username, :email
  validates_uniqueness_of :username
  validates_length_of :username, within: 1..12, too_long: 'username is too long', too_short: 'username is too short'
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  attr_accessor :current_password, :access_token

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

  acts_as_universal_and_determines_account

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

  def self.first_user_by_facebook_id(facebook_access_token)
    fb_user = Koala::Facebook::API.new(facebook_access_token)
    fb_details = fb_user.get_object("me")
    fb_id = fb_details["id"]
    User.where(uid: fb_id).first
  rescue
    nil
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
  
  def self.new_with_session(params,session)
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
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
      if user.blank?
       user = User.new
       user.password = Devise.friendly_token[0,10]
       user.password_confirmation = user.password
       user.name = auth.info.name
       user.email = auth.info.email
       parts = user.name.split(" ")
       user.username = parts[0][0].downcase + parts[1].downcase rescue user.name
       auth.provider == "twitter" ?  user.save(:validate => false) :  user.save
     end
     authorization.username = auth.info.nickname
     authorization.user_id = user.id
     authorization.save
   end
   authorization.user
 end
  
  
  
  
  
  
=begin  
  def self.find_for_oauth(auth, signed_in_resource = nil)
    return nil if  auth.blank? && signed_in_resource.blank?
      # Get the identity and user if they exist
      identity = Identity.find_for_oauth(auth)

      # If a signed_in_resource is provided it always overrides the existing user
      # to prevent the identity being locked with accidentally created accounts.
      # Note that this may leave zombie accounts (with no associated identity) which
      # can be cleaned up at a later date.
      user = signed_in_resource ? signed_in_resource : identity.user

      # Create the user if needed
      if user.nil?

        # Get the existing user by email if the provider gives us a verified email.
        # If no verified email was provided we assign a temporary email and ask the
        # user to verify it on the next step via UsersController.finish_signup
        email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
        email = auth.info.email if email_is_verified
        user = User.where(:email => email).first if email

        # Create the user if it's a new registration
        if user.nil?
          user = User.new(
            name: auth.extra.raw_info.name,
            #username: auth.info.nickname || auth.uid,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
          )
          user.skip_confirmation!
          user.save!
        end
      end

      # Associate the identity with the user if needed
      if identity.user != user
        identity.user = user
        identity.save!
      end
      user
    end
=end  
=begin
  def self.from_omniauth(auth)
    return nil if auth.blank?
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
=end   
   def email_verified?
       self.email && self.email !~ TEMP_EMAIL_REGEX
   end
=begin
   
   def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
     user = User.where(provider: auth.provider, uid: auth.uid).first
     #user = User.where(email: auth.info.email).first
     unless user
       user = User.find_or_create_by_email( first_name: auth.extra.raw_info.first_name,
                            last_name: auth.extra.raw_info.last_name,
                             provider: auth.provider,
                                  uid: auth.uid,
                                email: auth.info.email,
                             password: Devise.friendly_token[0,20],
                     remote_photo_url: "https://graph.facebook.com/#{auth.uid}/picture?height=256&width=256",
                             location: auth.info.location)
     end
     if !user.remote_photo_url || !user.location
       user.update_attributes(remote_photo_url: "https://graph.facebook.com/#{auth.uid}/picture?height=256&width=256",
                                      location: auth.info.location)
     end
     user
   end
=end
  private

  def ensure_address
    if address.nil?
      create_address
    end
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
#  tenant_id                    :integer
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
#
