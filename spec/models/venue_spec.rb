require 'spec_helper'

describe Venue do
  before(:each) do
    @venue = Fabricate(:venue)
  end

  describe "name_and_address" do
    it 'should return the right stuff' do
      expect(@venue.name_and_address).to eq("#{@venue.name} (#{@venue.address.street1} #{@venue.address.city}, #{@venue.address.state})")
    end
  end

  describe "address_has_fields" do
    context "street1 is empty" do
      it 'returns an error' do
        Venue.new(address: Address.new(street1: nil, city: "Florence", state: "Alabama", zip: "35630"), name: "venue", description: "description").should_not be_valid
      end
    end

    context "zip is empty" do

      it 'requires both state and city' do
        Venue.create(address: Address.new(zip: nil, city: "Florence", state: "Alabama", street1: "123 Monroe St."), name: "venue", description: "description").should be_valid
      end

      it 'fails if no city' do
        Venue.create(address: Address.new(zip: nil, city: nil, state: "Alabama", street1: "123 Monroe St."), name: "venue", description: "description").should_not be_valid
      end

      it 'fails if no state' do
        Venue.create(address: Address.new(zip: nil, city: "Florence", state: nil, street1: "123 Monroe St.")).should_not be_valid
      end

    end

    context "city and state are empty" do
      it 'requires a zip' do
        Venue.create(address: Address.new(zip: nil, city: nil, state: nil, street1: "123 Monroe St."), name: "venue", description: "description").should_not be_valid
      end

      it 'requires a zip' do
        Venue.create(address: Address.new(zip: "35630", city: nil, state: nil, street1: "123 Monroe St."), name: "venue", description: "description").should be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: venues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :string(255)
#  image_url       :string(255)
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  phone           :string(255)
#  email           :string(255)
#  hours_sunday    :string(255)
#  hours_monday    :string(255)
#  hours_tuesday   :string(255)
#  hours_wednesday :string(255)
#  hours_thusday   :string(255)
#  hours_friday    :string(255)
#  hours_saturday  :string(255)
#
