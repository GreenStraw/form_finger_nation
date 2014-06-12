class TeamSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url
  has_one :sport, key: :sport, root: :sport
  has_many :admins, key: :admins, root: :admins
  has_many :fans, key: :fans, root: :fans
  has_many :endorsed_hosts, key: :endorsed_hosts, root: :endorsed_hosts

  def admins
    User.with_role(:team_admin, object)
  end
end
