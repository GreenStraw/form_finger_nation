class Voucher < ActiveRecord::Base
  validates_presence_of :user, :package

  belongs_to :package
  belongs_to :user
end
