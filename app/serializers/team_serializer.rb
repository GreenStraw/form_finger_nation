class TeamSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url
  has_one :sport, key: :sport, root: :sport
  has_one :admin, key: :admin, root: :admin
  has_many :fans, key: :fans, root: :fans
  has_many :endorsed_hosts, key: :endorsed_hosts, root: :endorsed_hosts

  def admin
    User.with_role(:team_admin, object).first || nil
  end
end
