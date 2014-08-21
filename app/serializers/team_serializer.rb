class TeamSerializer < ImageSerializer
  attributes :name, :information, :sport_id, :college, :website
  has_one :address
  has_many :admins, embed: :ids
  has_many :fans, embed: :ids
  has_many :venue_fans, embed: :ids
  has_many :hosts, embed: :ids
  has_many :endorsement_requests, embed: :ids

  private

  def admins
    object.admins
  end
end
