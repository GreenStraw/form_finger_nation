class User < ActiveRecord::Base
  rolify
  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_universal_and_determines_account

  # Role-based access control
  enumerize :role, in: [:client, :staff, :admin], default: :staff, scope: true, predicates: true

  has_many :comments, as: :commenter
  has_many :favorites, as: :favoriter, dependent: :destroy
  has_many :sports, through: :favorites, source: :favoritable, source_type: "Sport"
  has_many :teams, through: :favorites, source: :favoritable, source_type: "Team"
  has_many :endorsements, as: :endorsable
  has_many :endorsing_teams, through: :endorsements, source: :endorser, source_type: "Team"
  has_many :party_reservations
  has_many :reservations, through: :party_reservations, source: :party
  has_many :party_invitations
  has_many :invitations, through: :party_invitations, source: :party
  has_many :parties, foreign_key: 'organizer_id'
  has_many :user_purchased_packages
  has_many :packages, through: :user_purchased_packages
  has_one :address, as: :addressable, dependent: :destroy


  def full_name
    [first_name, last_name].join(' ')
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    if auth.respond_to?(:info)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first

      unless user
        user = User.create(:username => auth.info.name,
                        :provider => auth.provider,
                        :uid => auth.uid,
                        :email => auth.info.email,
                        :password => Devise.friendly_token[0,20]
        )
      end
      user
    else
      return nil
    end
  end

end
