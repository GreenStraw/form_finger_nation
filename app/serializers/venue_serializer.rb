class VenueSerializer < ImageSerializer
  attributes :name, :description, :phone, :email, :hours_sunday, :hours_monday, :hours_tuesday, :hours_wednesday, :hours_thursday, :hours_friday, :hours_saturday, :website
  has_one :address
  has_many :followed_teams, embed: :ids
  has_many :followed_sports, embed: :ids
  has_many :parties, embed: :ids
  has_many :managers, embed: :ids
  has_many :packages, embed: :ids, include: true

  private

  def managers
    User.with_role(:manager, object)
  end
end
