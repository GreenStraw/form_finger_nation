require 'spec_helper'

describe Address do
  before(:each) do
    @address = Fabricate(:address)
  end
  describe 'full_street_address' do
    it 'should formatted street address' do
      fmt = "#{@address.street1} #{@address.street2} #{@address.city}, #{@address.state} #{@address.zip}"
      expect(@address.full_street_address).to eq(fmt)
    end
  end

  describe "zip_or_city_and_state" do
    context "street1 is empty" do
      it "should fail" do
        expect(Address.new(street1: nil, city: "Florence", state: "Alabama", zip: "35630")).to_not be_valid
      end
    end

    context "state and zip are empty" do
      it 'should fail' do
        expect(Address.new(street1: "123 Monroe St.", city: "Florence", state: nil, zip: nil)).to_not be_valid
      end
    end

    context "zip is empty" do
      it 'should not fail' do
        expect(Address.new(street1: "123 Monroe St.", city: "Florence", state: "Alabama", zip: nil)).to be_valid
      end
    end

    context "city and zip are empty" do
      it 'should fail' do
        expect(Address.new(street1: "123 Monroe St.", city: nil, state: "Alabama", zip: nil)).to_not be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  addressable_id   :integer
#  addressable_type :string(255)
#  street1          :string(255)
#  street2          :string(255)
#  city             :string(255)
#  state            :string(255)
#  zip              :string(255)
#  latitude         :float
#  longitude        :float
#  created_at       :datetime
#  updated_at       :datetime
#
