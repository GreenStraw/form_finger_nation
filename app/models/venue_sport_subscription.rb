class VenueSportSubscription < ActiveRecord::Base
  belongs_to :venue
  belongs_to :sport
end
