require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { Fabricate(:user) }
  before do
    user
    user.confirm!
  end

  describe 'GET show' do
    context 'wrong token' do
      before {
        request.headers['auth-token'] = 'fake_token'
        request.headers['auth-email'] = user.email
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
        get :show, id: user.id
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'PUT update' do
    context 'Invalid credentials no auth token' do
      before do
        user = Fabricate(:user)
        user.confirm!
        user.ensure_authentication_token!
        xhr :put, :update, :id => user.id, :user => {:name => "NoToken NewName"}
      end
      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'Update password' do
      before do
        @user = Fabricate(:user)
        @user.confirm!
        @user.ensure_authentication_token!
        request.headers['auth-token'] = @user.authentication_token
        request.headers['auth-email'] = @user.email
        xhr :put,
            :update,
            :id => @user.id,
            :user => {:current_password => @user.password,
                      :password => "abcdefgh",
                      :password_confirmation => "abcdefgh"}
      end
      it 'returns http 201' do
        response.response_code.should == 200
      end
      it 'returns updated user' do
        up_user = JSON.parse(response.body)['user']
        expect_user = {
          'id' => @user.id,
          'name' => @user.name,
          'email' => @user.email,
          'city' => @user.city,
          'state' => @user.state,
          'zip' => @user.zip,
          'admin' => @user.has_role?(:admin),
          'sports' => @user.sports,
          'teams'=> @user.teams,
          'venues' => @user.venues,
          'parties' => @user.parties,
          'reservations' => @user.reservations,
          'invitations' => @user.invitations,
          'employer' => @user.employer,
          'endorsing_teams' => @user.endorsing_teams}
        up_user.should == expect_user
      end
    end
    context 'Update fields' do
      before do
        @user = Fabricate(:user)
        @user.confirm!
        @user.ensure_authentication_token!
        request.headers['auth-token'] = @user.authentication_token
        request.headers['auth-email'] = @user.email
        xhr :put,
            :update,
            :id => @user.id,
            :user => {:current_password => @user.password,
                      :name => "New Name"}
      end
      it 'returns http 201' do
        response.response_code.should == 200
      end
      it 'returns updated user' do
        up_user = JSON.parse(response.body)['user']
        expect_user = {
          'id' => @user.id,
          'name' => "New Name",
          'email' => @user.email,
          'city' => @user.city,
          'state' => @user.state,
          'zip' => @user.zip,
          'admin' => @user.has_role?(:admin),
          'sports' => @user.sports,
          'teams'=> @user.teams,
          'venues' => @user.venues,
          'parties' => @user.parties,
          'reservations' => @user.reservations,
          'invitations' => @user.invitations,
          'employer' => @user.employer,
          'endorsing_teams' => @user.endorsing_teams}
        up_user.should == expect_user
      end
    end
    context 'Invalid credentials wrong auth token' do
      before do
        @user = Fabricate(:user)
        @user.confirm!
        @user.ensure_authentication_token!
        request.headers['auth-token'] = 'fake_token'
        request.headers['auth-email'] = @user.email
        xhr :put,
            :update,
            :id => @user.id,
            :user => {:current_password => @user.password,
                      :name => "New Name"}
      end
      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'Invalid Password' do
      before do
        @user = Fabricate(:user)
        @user.confirm!
        @user.ensure_authentication_token!
        request.headers['auth-token'] = @user.authentication_token
        request.headers['auth-email'] = @user.email
        xhr :put,
            :update,
            :id => @user.id,
            :user => {:current_password => 'wrongPassword',
                      :passwrod => 'test',
                      :password_confirmation => 'test',
                      :name => "New Name"}
      end
      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
  end
end
