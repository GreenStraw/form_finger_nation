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

    reservations = current_user.party_reservations.where(user_id: current_user.id)

    reservedPartyIDs = reservations.map(&:party_id)

    creatorOfParties = where("redeemed_at IS ?", nil)

    redeemableVouchers = []

    creatorOfParties.try(:each) do |voucher|
        if reservedPartyIDs.include? voucher.party_id && voucher.user_id != current_user.id
          redeemableVouchers.concat(voucher)
        end
    end

    return redeemableVouchers

    #where("(redeemed_at IS ? AND user_id = ? ) OR (party_id IN (?) AND user_id != ? ) ", nil, current_user.id, reservedPartyIDs, current_user.id)

  end

  def self.redeemed(current_user)
    where("redeemed_at IS NOT ? AND user_id = ?", nil, current_user.id)
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
