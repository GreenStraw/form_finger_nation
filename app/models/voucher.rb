class Voucher < ActiveRecord::Base
  validates_presence_of :user, :package, :party

  belongs_to :package
  belongs_to :user
  belongs_to :party

  def verify
    req = Zooz::Request::Verify.new

    # Run in sandbox mode
    # TODO MAKE THIS DEPENDENT ON ENVIRONMENT
    req.sandbox = true#Rails.env != "production"

    # Enter your details
    req.developer_id = ENV['ZOOZ_DEVELOPER_ID']
    req.app_key = ENV['ZOOZ_API_KEY']

    # Set the details of the transaction
    req.trx_id = self.transaction_id

    # Make the request
    resp = req.request
    [resp.success?, resp.response.try(:errors).try(:first) || nil]
  end
end


public
  def test_submit
    zooz_submit
  end
private
  def zooz_submit 
    req = Zooz::Request.new
    req.response_type = 'NVP'
    req.sandbox = (Rails.env == "production" ? false : true)
    req.cmd="openTrx"
    req.set_header("ZooZAppKey", ENV['ZOOZ_APP_KEY'])
    req.set_header("ZooZResponseType", "NVP")
    req.set_param("amount", "55.00")
    req.set_param("currencyCode", "USD")
    req.set_param("cmd", "openTrx")

    if req.valid? 
      resp = req.request
      token = resp.token # the token is needed to create the transaction.
    else
      token = nil
    end
    token
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
