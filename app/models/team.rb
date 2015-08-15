class Team < ActiveRecord::Base
  resourcify
  validates_presence_of :name
  validates_presence_of :sport_id
  after_create :ensure_address
  mount_uploader :image_url, TeamImageUploader
  skip_callback :commit, :after, :remove_image_url!
  mount_uploader :banner, BannerUploader

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

  def self.ordered_teams(teams)
    grouped_teams = teams.group_by{|t| t.sport.name}
    sport_names_with_teams = Sport.ordered_sports
    ordered_teams = {}
    sport_names_with_teams.each do |sport_name, teams|
      ordered_teams[sport_name] = teams
    end
    ordered_teams
  end

  def admins
    User.with_role(:team_admin, self) || []
  end

  def upcoming_parties
    self.parties.where('scheduled_for > ?', Time.now).order(:scheduled_for)
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
#
