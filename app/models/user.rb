class User < ActiveRecord::Base
  include Concerns::TokenAuthenticatable
  extend Enumerize
  rolify
  after_create :ensure_address

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
          :registerable

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
