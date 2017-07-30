class Voucher < ActiveRecord::Base
  validates_presence_of :user, :package, :party

  belongs_to :package
  belongs_to :user
  belongs_to :party


  def verify
    req = Zooz::Request::Verify.new

    # Run in sandbox mode
    # TODO MAKE THIS DEPENDENT ON ENVIRONMENT
    req.sandbox = ENV['ZOOZ_SANDBOX'] == "true" ? true : false

    # Enter your details
    req.developer_id = ENV['ZOOZ_DEVELOPER_ID']
    req.app_key = ENV['ZOOZ_API_KEY']

    # Set the details of the transaction
    req.trx_id = self.transaction_id

    # Make the request
    resp = req.request
    [resp.success?, resp.response.try(:errors).try(:first) || nil]
  end

  def self.redeemable(current_user)

    where("user_id = ?", current_user.id)

    #where("redeemed_at is NULL")
  end

  def self.redeemed
    where("redeemed_at is not NULL")
  end


end







# == Schema Information
#
# Table name: vouchers
#
#  id                     :integer          not null, primary key
#  transaction_display_id :string(255)
#  transaction_id         :string(255)
#  redeemed_at            :datetime
#  user_id                :integer
#  package_id             :integer
#  party_id               :integer
#  created_at             :datetime
#  updated_at             :datetime
#
