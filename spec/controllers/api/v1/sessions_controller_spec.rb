require 'spec_helper'

describe Api::V1::SessionsController do
  render_views

  before { }

  before(:each) do
    login(:admin)
    @fb_user = Fabricate(:user, uid: '123', provider: 'facebook')
    @request.env["devise.mapping"] = Devise.mappings[:api_v1_user]
  end

  describe 'POST create' do
    context 'no param' do
      before { post :create }

      it_behaves_like 'http code', 400
    end

    context 'wrong credentials' do
      before { post :create, email: @current_user.email, password: '' }

      it_behaves_like 'http code', 401
    end

    context 'normal email + password auth' do
      before {
        post :create, email: @current_user.email, password: @current_user.password
      }

      subject { JSON.parse response.body }

      it { should include 'user_id' }
      it { should include 'auth_token' }

      it 'returns http 201' do
        response.response_code.should == 201
      end
    end

    context 'facebook auth' do
      it_behaves_like 'auth response' do
        let(:params) do
          {
            email: @fb_user.email, uid: @fb_user.uid, provider: @fb_user.provider
          }
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'no param' do
      before { delete :destroy }

      it_behaves_like 'http code', 400
    end

    context 'wrong credentials' do
      before { delete :destroy, auth_token: '' }

      it_behaves_like 'http code', 401
    end

    context 'normal auth token param' do
      before { delete :destroy, auth_token: @current_user.authentication_token }
      subject { JSON.parse response.body }

      it { should include 'user_id' }

      it_behaves_like 'http code', 200
    end
  end
end
