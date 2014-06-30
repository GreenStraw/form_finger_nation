class User < ActiveRecord::Base
  include TokenAuthenticatable
  extend Enumerize
  rolify
  after_create :ensure_address

  # validate :password_on_create_with_email, only: :create
  validates_presence_of :password_confirmation, only: :create, if: '!password.nil?'
  validates_presence_of :username, :email

  attr_accessor :current_password

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
  has_many :sports, through: :favorites, source: :favoritable, source_type: "Sport"
  has_many :teams, through: :favorites, source: :favoritable, source_type: "Team"
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

  def self.first_user_by_facebook_access_token(token)
    user = User.where(facebook_access_token: token).first
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
