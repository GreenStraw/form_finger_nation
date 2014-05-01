require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { Fabricate(:user) }
  before do
    user
    user.confirm!
  end

  describe 'GET show' do
    context 'unauthorized' do
      before {
        subject.stub(:current_user).and_return(user)
        get :show, id: user.id }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end

    context 'wrong token' do
      before {
        request.headers['auth-token'] = 'fake_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        get :show, id: user.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end

    context 'authorized' do
      before do
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        get :show, id: user.id
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end
end
