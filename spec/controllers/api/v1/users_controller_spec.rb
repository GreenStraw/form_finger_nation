require 'spec_helper'

describe Api::V1::UsersController do
  render_views
  
  let(:user) { Fabricate(:user) }
  before do
    create_new_tenant
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
          'username' => nil,
          'email' => @user.email,
          'admin' => @user.has_role?(:admin),
          'favorite_sport_ids' => @user.sports,
          'favorite_team_ids'=> @user.teams,
          'party_ids' => @user.parties,
          'reservation_ids' => @user.reservations,
          'invitation_ids' => @user.invitations,
          'employer_ids' => [],
          'first_name' => nil,
          'last_name' => nil,
          'address_id' => nil,
          'endorsing_team_ids' => @user.endorsing_teams,
          'managed_venue_ids' => [],
          'purchased_packages' => [],
          'first_name' => 'Test',
          'last_name' => 'User'}
        up_user.should == expect_user
      end
    end
    context 'Update fields' do
      before do
        @user = Fabricate(:user)
        @user.confirm!
        request.headers['auth-token'] = @user.authentication_token
        request.headers['auth-email'] = @user.email
        xhr :put,
            :update,
            :id => @user.id,
            :user => {:current_password => @user.password,
                      :username => "NewName"}
      end
      it 'returns http 201' do
        response.response_code.should == 200
      end
      it 'returns updated user' do
        up_user = JSON.parse(response.body)['user']
        expect_user = {
          'id' => @user.id,
          'username' => "NewName",
          'email' => @user.email,
          'admin' => @user.has_role?(:admin),
          'favorite_sport_ids' => @user.sports,
          'favorite_team_ids'=> @user.teams,
          'party_ids' => @user.parties,
          'reservation_ids' => @user.reservations,
          'invitation_ids' => @user.invitations,
          'employer_ids' => [],
          'first_name' => nil,
          'last_name' => nil,
          'address_id' => nil,
          'endorsing_team_ids' => @user.endorsing_teams,
          'managed_venue_ids' => [],
          'purchased_packages' => [],
          'first_name' => 'Test',
          'last_name' => 'User'}
        up_user.should == expect_user
      end
    end
    context 'Invalid credentials wrong auth token' do
      before do
        @user = Fabricate(:user)
        @user.confirm!
        request.headers['auth-token'] = 'fake_token'
        request.headers['auth-email'] = @user.email
        xhr :put,
            :update,
            :id => @user.id,
            :user => {:current_password => @user.password,
                      :username => "NewName"}
      end
      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'Invalid Password' do
      before do
        @user = Fabricate(:user)
        @user.confirm!
        request.headers['auth-token'] = @user.authentication_token
        request.headers['auth-email'] = @user.email
        xhr :put,
            :update,
            :id => @user.id,
            :user => {:current_password => 'wrongPassword',
                      :passwrod => 'test',
                      :password_confirmation => 'test',
                      :username => "NewName"}
      end
      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
  end
end
