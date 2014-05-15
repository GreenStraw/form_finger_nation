class PartyInvitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :party
end
