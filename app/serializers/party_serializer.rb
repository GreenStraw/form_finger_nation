class PartySerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :description, :scheduled_for, :scheduled_date, :scheduled_time, :private
  has_many :attendees, key: :attendees, root: :attendees
  has_one :organizer, key: :organizer, root: :organizer#, include: true
  has_one :team, key: :team, root: :team#, include: true
  has_one :sport, key: :sport, root: :sport#, include: true
  has_one :venue, key: :venue, root: :venue#, include: true

  def scheduled_date
    object.scheduled_for.to_date
  end
  def scheduled_time
    object.scheduled_for.strftime('%I:%M %P')
  end
end
