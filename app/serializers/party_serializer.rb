class PartySerializer < BaseSerializer
  attributes :name, :description, :scheduled_for, :is_private, :verified
  has_one :address
  has_many :party_invitations, embed: :ids
  has_many :unregistered_attendees, embed: :ids
  has_many :attendees, embed: :ids
  has_many :comments, embed: :ids
  has_many :packages, embed: :ids
  has_one :organizer, embed: :ids
  has_one :team, embed: :ids
  has_one :sport, embed: :ids
  has_one :venue, embed: :ids

  private

  def unregistered_attendees
    object.party_reservations.where(:user_id => nil)
  end

  def comments
    object.root_comments
  end
end
