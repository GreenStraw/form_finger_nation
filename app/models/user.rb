class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :omniauthable, :omniauth_providers => [:facebook]

  validates :email, presence: true

  has_many :sport_subscriptions
  has_many :sports, through: :sport_subscriptions
  has_many :team_subscriptions
  has_many :teams, through: :team_subscriptions
  has_many :establishments

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
