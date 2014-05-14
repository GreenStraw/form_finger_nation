class WatchPartyReservation < ActiveRecord::Base
  belongs_to :attendee, class_name: 'User'
  belongs_to :watch_party
end
