require 'spec_helper'

describe Voucher do
  before(:each) do
    @voucher = Fabricate(:voucher)
  end
  describe "verify" do
    before(:each) do
      @req = Zooz::Request::Verify.new
      @response = Zooz::Response::Verify.new
      @req.should_receive(:request).and_return(@response)
      Zooz::Request::Verify.should_receive(:new).and_return(@req)
    end
    context "success" do
      before {
        @response.should_receive(:success?).and_return(true)
      }
      it "returns [true, nil]" do
        expect(@voucher.verify).to eq([true, nil])
      end
    end
    context "failure" do
      before {
        @response.should_receive(:success?).and_return(false)
      }
      it "returns [false, errors]" do
        expect(@voucher.verify).to eq([false, nil])
      end
    end
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
