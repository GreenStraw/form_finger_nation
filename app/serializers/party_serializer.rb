class PartySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :scheduled_for, :is_private, :verified, :address
  has_many :party_invitations, key: :invitation_ids, root: :invitation_ids
  has_many :unregistered_attendees, key: :unregistered_attendee_ids, root: :unregistered_attendee_ids
  has_many :attendees, key: :attendee_ids, root: :attendee_ids
  has_many :comments, key: :comment_ids, root: :comment_ids
  has_many :packages, key: :package_ids, root: :package_ids
  has_one :organizer, key: :organizer_id, root: :organizer_id#, include: true
  has_one :team, key: :team_id, root: :team_id#, include: true
  has_one :sport, key: :sport_id, root: :sport_id#, include: true
  has_one :venue, key: :venue_id, root: :venue_id

  def address
    object.address
  end

  def unregistered_attendees
    object.party_reservations.where(:user_id => nil)
  end

  def comments
    object.root_comments
  end
end
