class SportSerializer < BaseSerializer
  attributes :name, :image_url
  has_many :fans, embed: :ids
  has_many :venue_fans, embed: :ids
  has_many :teams, embed: :ids
end
