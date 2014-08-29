class Package < ActiveRecord::Base
  validates :name, presence: true

  has_many :party_packages
  has_many :parties, through: :party_packages, dependent: :destroy
  has_many :vouchers
  belongs_to :venue
  mount_uploader :image_url, ImageUploader

  def self.zooz_submit(zooz_params)
    req = Zooz::Request.new
    req.response_type = 'NVP' #override the default JSON for the web app submission (because of the sandbox account created to handle the requests)
    req.cmd=zooz_params[:cmd]
    req.set_param("amount", zooz_params[:amount])
    req.set_param("currencyCode", zooz_params[:currency_code])
    req.set_param("cmd", zooz_params[:cmd])
    begin
      if req.valid?
        resp = req.request.parsed_response
        token = resp["token"].first # the token is needed to create the transaction.
      else
        token = nil
      end
    rescue
      token = nil
    end
    token
  end

    def total_purchased
      vouchers.count.to_s
    end
end

# == Schema Information
#
# Table name: packages
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  image_url   :string(255)
#  price       :decimal(, )
#  active      :boolean
#  is_public   :boolean          default(FALSE)
#  start_date  :datetime
#  end_date    :datetime
#  venue_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#
