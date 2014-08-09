class UserPurchasedPackage < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  belongs_to :party
end

# == Schema Information
#
# Table name: user_purchased_packages
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  package_id :integer
#  party_id   :integer
#  charge_id  :string(255)
#  created_at :datetime
#  updated_at :datetime
#
