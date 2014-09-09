class User < ActiveRecord::Base
  include Concerns::TokenAuthenticatable
  extend Enumerize
  rolify
  after_create :ensure_address
  mount_uploader :image_url, ImageUploader

  # validate :password_on_create_with_email, only: :create
  validates_presence_of :password_confirmation, only: :create, if: '!password.nil?'
  validates_presence_of :username, :email
  validates_uniqueness_of :username
  validates_length_of :username, within: 1..12, too_long: 'username is too long', too_short: 'username is too short'
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  REQUESTED_ROLES = ['Sports Fan', 'Alumni Group', 'Venue']

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

  def admin?
    self.has_role?(:admin)
  end

  def managed_venues
    if self.admin?
      Venue.all
    elsif self.has_role?(:manager, :any)
      Venue.where(id: self.roles.where(name: 'manager').map(&:resource_id))
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

  def data
    {
      user_id: self.id,
      auth_token: self.authentication_token,
      auth_email: self.email,
      user_name: "#{self.first_name} #{self.last_name}",
      user_admin: self.has_role?(:admin)
    }
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

  def send_welcome_email
    if self.requested_role == 'Sports Fan'
      UserMailer.welcome_email(self).deliver
    elsif self.requested_role == 'Alumni Group'
      UserMailer.alumni_group_email(self).deliver
    else
      UserMailer.venue_email(self).deliver
    end
  end

  private

  def ensure_address
    create_address if address.nil?
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
#  name                         :string(255)
#
