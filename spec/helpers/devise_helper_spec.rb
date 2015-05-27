require 'spec_helper'

describe DeviseHelper do
  before do
    view.stub(:resource).and_return(User.new)
    view.stub(:resource_name).and_return(:user)
    view.stub(:devise_mapping).and_return(Devise.mappings[:user])
  end

  describe "No Error Message" do
    it 'should ' do
      helper.devise_error_messages!.should eql("")
    end
  end

  describe "Error Message Present" do
    it "should not be blank" do
      view.stub(:resource).and_return(User.create)  
      helper.devise_error_messages!.should_not eql("")
    end
  end

end