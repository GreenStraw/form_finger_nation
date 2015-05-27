require 'spec_helper'

describe Sport do
  before(:each) do
    @sport = Fabricate(:sport)
  end
  
end

# == Schema Information
#
# Table name: sports
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image_url  :string(255)
#  created_at :datetime
#  updated_at :datetime
#
