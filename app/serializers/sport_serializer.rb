class SportSerializer < BaseSerializer
  attributes :id, :name, :image_url
  has_many :fans, key: :fan_ids, root: :fan_ids
  has_many :venue_fans, key: :venue_fan_ids, root: :venue_fan_ids
  has_many :teams, key: :team_ids, root: :team_ids#, include: true
end
