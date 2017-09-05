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

    #creatorParty = where("redeemed_at IS ? AND user_id = ?", nil, current_user.id)

    #if creatorParty.present?
    #  return creatorParty
    #else

      voucher = []

      reservations = current_user.party_reservations.where(user_id: current_user.id)
      reservedPartyIDs = reservations.map(&:party_id)

      grouped_reserved_vouchers = where(party_id: reservedPartyIDs).group_by{|v| [v.party_id, v.package_id] }

      grouped_reserved_vouchers.try(:each) do |(partyid, pkgid) , rv|

          user_redeemed_voucher = where("user_id = ? AND redeemed_at IS NOT ? AND party_id = ? AND package_id = ?",  current_user.id, nil, partyid, pkgid)

          if !user_redeemed_voucher.present?

              voucher_copy = where("party_id = ? AND package_id = ?", partyid, pkgid).first
              voucher_copy.assign_attributes(:user_id  => current_user.id, :redeemed_at => nil)
              voucher << voucher_copy

          else
              voucher << user_redeemed_voucher.first
          
          end

      #end

      return voucher
    
    end

  end

  def self.redeemStatus(package_id, user_id, party_id)
      where("package_id = ? AND user_id = ? AND party_id = ?", package_id, user_id, party_id)
  end

  def self.redeemed
    #where("redeemed_at IS NOT ? AND user_id = ?", nil, current_user.id)
    where("redeemed_at IS NOT ?", nil)
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
