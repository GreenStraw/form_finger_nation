require 'spec_helper'

describe Api::V1::RegistrationsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:api_v1_user]
  end

  describe 'POST create' do
    context 'registration error' do
      before { post :create, :user => {:user => {}} }
      it 'returns http 422' do
       response.response_code.should == 422
      end
    end
    context 'registration success' do
      before do
        user = Fabricate.attributes_for(:user)
        user[:password_confirmation] = user[:password]
        xhr :post, :create, :user => user
      end
      it 'returns http 201' do
        response.response_code.should == 201
      end
    end
  end
  context 'facebook access token good' do
    before do
      user = Fabricate.attributes_for(:user)
      user[:access_token] = 'test'
      subject.should_receive(:facebook_params).once
      xhr :post, :create, user: user
    end
    it 'returns http 201' do
      response.response_code.should == 201
    end
  end
end
