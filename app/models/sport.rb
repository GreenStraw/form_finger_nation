class Sport < ActiveRecord::Base
  validates :name, presence: true

  has_many :teams, dependent: :destroy
  has_many :favorites, as: :favoritable
  has_many :fans, through: :favorites, source: :favoriter, source_type: "User"
  has_many :venue_fans, through: :favorites, source: :favoriter, source_type: "Venue"

  mount_uploader :image_url, SportImageUploader
  skip_callback :commit, :after, :remove_image_url!

  SPORT_ORDER = ['NFL', 'NCAA-FOOTBALL', 'MLB', 'NCAA-BASEBALL', 'NBA', 'NCAA-BASKETBALL', 'SOCCER']

  def self.ordered_sports
    sport_order = Sport::SPORT_ORDER
    sport_order += Sport.all.reject{|s| sport_order.include?(s.name)}.map(&:name)
    sport_names_with_teams = {}
    sport_order.each do |sport_name|
      sport = Sport.find_by_name(sport_name)
      sport_names_with_teams[sport_name] = sport.teams if sport.present? && sport.teams.any?
    end
    sport_names_with_teams
  end
end

# == Schema Information
#
# Table name: sports
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image_url  :string(255)
#  created_at :datetime
#  updated_at :datetime
#
