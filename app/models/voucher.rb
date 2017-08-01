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

    creatorParty = where("redeemed_at IS ? AND user_id = ?", nil, current_user.id)

    if creatorParty.present?
      return creatorParty
    else

      voucher = []

      reservations = current_user.party_reservations.where(user_id: current_user.id)
      reservedPartyIDs = reservations.map(&:party_id)

      reserved_vouchers = where(party_id: reservedPartyIDs)
      
      if reserved_vouchers.present?

        user_voucher = reserved_vouchers.where(user_id:  current_user.id, redeemed_at: nil)

        reserved_vouchers.try(:each) do |rv|

            #newRecipient = Voucher.new
            rv.assign_attributes(:user_id  => current_user.id)
            
            #newRecipient = { "user_id"  => current_user.id, "party_id" => rv.party_id, "package_id" => rv.package_id }
            voucher << newRecipient

        end

        return voucher

      else

        []

      end
    
    end

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
