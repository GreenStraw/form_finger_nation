require 'spec_helper'

describe Authorization do
  before(:each) do
    @authorization = Fabricate(:authorization)
  end
  
  describe 'fetch_details' do
    it 'should call fetch_details_from_provider' do
      @authorization.provider = 'provider'
      @authorization.should_receive(:fetch_details_from_provider).and_return(nil)
      expect(@authorization.fetch_details).to eq(nil)
    end
  end

  describe 'fetch_details_from_facebook' do
    it 'should return nil' do
      @authorization.token = 'token'
      fbdata = double(:fbdata)
      Koala::Facebook::API.should_receive(:new).with('token').and_return(fbdata)
      fbdata.should_receive(:get_object).with('me').and_return({'username'=>'username'})
      expect(@authorization.fetch_details_from_facebook).to eq(@authorization)
    end
  end

  describe 'fetch_details_from_twitter' do
    it 'should return nil' do
      expect(@authorization.fetch_details_from_twitter).to eq(@authorization)
    end
  end

  describe 'fetch_details_from_github' do
    it 'should return nil' do
      expect(@authorization.fetch_details_from_github).to eq(@authorization)
    end
  end

  describe 'fetch_details_from_linkedin' do
    it 'should return nil' do
      expect(@authorization.fetch_details_from_linkedin).to eq(@authorization)
    end
  end

  describe 'fetch_details_from_google_oauth2' do
    it 'should return nil' do
      expect(@authorization.fetch_details_from_google_oauth2).to eq(@authorization)
    end
  end

end

# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  user_id    :integer
#  token      :string(255)
#  secret     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  username   :string(255)
#
