class Package < ActiveRecord::Base
  validates_presence_of :venue_id

  belongs_to :venue
end
