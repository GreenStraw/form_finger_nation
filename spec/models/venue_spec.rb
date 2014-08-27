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
