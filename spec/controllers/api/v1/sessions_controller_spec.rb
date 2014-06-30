require 'spec_helper'

describe Api::V1::SessionsController do
  render_views

  before { }

  before do
    create_new_tenant
    login(:admin)
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

      it { should include 'user' }
      it 'returns http 201' do
        response.response_code.should == 201
      end
    end
    context 'access_token' do
      context 'user found' do
        before do
          User.should_receive(:first_user_by_facebook_access_token).with('test').and_return(@current_user)
          post :create, access_token: 'test', format: :json
        end

        it 'returns http 201' do
          response.response_code.should eq(201)
        end
      end
      context 'user not found' do
        before do
          User.should_receive(:first_user_by_facebook_access_token).with('test').and_return(nil)
          post :create, access_token: 'test', format: :json
        end

        it 'returns http 422' do
          response.response_code.should eq(401)
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
