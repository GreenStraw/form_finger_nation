class VenueSerializer < BaseSerializer
  attributes :name, :image_url, :description
  has_one :address
  has_many :followed_teams, embed: :ids
  has_many :followed_sports, embed: :ids
  has_many :parties, embed: :ids
  has_many :managers, embed: :ids
  has_many :packages, embed: :ids

  private

  def managers
    User.with_role(:manager, object)
  end
end
