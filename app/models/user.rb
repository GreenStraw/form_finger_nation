class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :omniauthable, :omniauth_providers => [:facebook]

  validates :email, presence: true

  has_many :user_sport_subscriptions
  has_many :sports, through: :user_sport_subscriptions
  has_many :user_team_subscriptions
  has_many :teams, through: :user_team_subscriptions
  has_many :venues
  has_many :party_reservations
  has_many :reservations, through: :party_reservations, source: :party
  has_many :party_invitations
  has_many :invitations, through: :party_invitations, source: :party
  has_many :parties, foreign_key: 'organizer_id'

  attr_accessor :current_password, :password_confirmation

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :admin
  # TODO: hack. This field needs to be part of the ember data model for updates, but
  # we generally don't want it for controller actions
  # attr_accessible :title, :body

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    if auth.respond_to?(:info)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first

      unless user
        user = User.create(:name => auth.info.name,
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
