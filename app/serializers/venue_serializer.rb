class VenueSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url, :description
  has_many :favorite_teams, key: :favorite_team_ids, root: :favorite_team_ids
  has_many :favorite_sports, key: :favorite_sport_ids, root: :favorite_sport_ids
  has_many :parties, key: :party_ids, root: :party_ids
  has_many :managers, key: :manager_ids, root: :manager_ids
  has_one :address, key: :address_id, root: :address_id

  def managers
    User.with_role(:manager, object)
  end
end
