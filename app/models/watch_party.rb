class WatchParty < ActiveRecord::Base
  has_many :watch_party_reservations
  has_many :attendees, through: :watch_party_reservations, class_name: 'User', foreign_key: 'attendee_ids'
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  belongs_to :team
  belongs_to :sport
  belongs_to :establishment

  attr_accessor :scheduled_date, :scheduled_time
end
