class TeamSerializer < BaseSerializer
  attributes :name, :information, :sport_id, :college, :website, :image_url
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

  def image_url
    if object.image_url.present?
      object.image_url_url
    else
      object.sport.image_url_url
    end
  end
end
