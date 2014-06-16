class UserPurchasedPackage < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  belongs_to :party
end
