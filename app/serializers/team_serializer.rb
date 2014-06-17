class TeamSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url, :information
  has_many :admins, key: :admin_ids, root: :admin_ids
  has_many :fans, key: :fan_ids, root: :fan_ids
  has_many :venue_fans, key: :venue_fan_ids, root: :venue_fan_ids
  has_many :endorsed_hosts, key: :endorsed_host_ids, root: :endorsed_host_ids
  has_one :sport, key: :sport_id, root: :sport_id
  has_one :address, key: :address_id, root: :address_id

  def admins
    User.with_role(:team_admin, object) || []
  end
end
