class SportSerializer < ImageSerializer
  attributes :name
  has_many :fans, embed: :ids
  has_many :venue_fans, embed: :ids
  has_many :teams, embed: :ids
end
