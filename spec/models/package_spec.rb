require 'spec_helper'

describe Package do
  
  describe "check total purchased" do
    before(:each) do
      @package = Fabricate(:package)
    end
    
    it "returns 0 vouchers purchased for this package, when none have been created" do
      expect(@package.total_purchased).to eq("0")
    end
    
    it "returns the correct number of vouchers when some have been created" do
      (1..5).each do |v|
        @voucher = Fabricate(:voucher, :package => @package)
      end
      expect(@package.total_purchased).to eq("5")
    end
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
