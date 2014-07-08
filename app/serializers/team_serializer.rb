class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_url, :information, :address, :sport_id
  has_many :admins, key: :admin_ids, root: :admin_ids
  has_many :fans, key: :fan_ids, root: :fan_ids
  has_many :venue_fans, key: :venue_fan_ids, root: :venue_fan_ids
  has_many :hosts, key: :host_ids, root: :host_ids
  has_many :endorsement_requests, key: :endorsement_request_ids, root: :endorsement_request_ids
  # has_one :sport, key: :sport_id, root: :sport_id

  def address
    object.address
  end

  def admins
    User.with_role(:team_admin, object) || []
  end
end
