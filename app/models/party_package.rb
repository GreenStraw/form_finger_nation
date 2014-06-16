class PartyPackage < ActiveRecord::Base
  belongs_to :party
  belongs_to :package
end
