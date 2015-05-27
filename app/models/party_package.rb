class PartyPackage < ActiveRecord::Base
  belongs_to :party
  belongs_to :package
end

# == Schema Information
#
# Table name: party_packages
#
#  id         :integer          not null, primary key
#  party_id   :integer
#  package_id :integer
#  created_at :datetime
#  updated_at :datetime
#
