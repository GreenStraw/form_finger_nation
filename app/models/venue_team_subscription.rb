class VenueTeamSubscription < ActiveRecord::Base
  belongs_to :venue
  belongs_to :team
end
