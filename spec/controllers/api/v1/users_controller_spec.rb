require 'spec_helper'

describe Api::V1::UsersController do
  render_views

  let(:user) { Fabricate(:user) }
  before do
    create_new_tenant
    login(:admin)
    @sport = Fabricate(:sport)
    @team = Fabricate(:team)
    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  describe 'GET show' do
    context 'wrong token' do
      before {
        request.headers['auth-token'] = 'fake_token'
        get :show, id: @current_user.id, format: :json
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end

    context 'authorized' do
      before do
        get :show, id: @current_user.id, format: :json
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
        request.headers['auth-token'] = nil
        xhr :put, :update, :id => @current_user.id, :user => {:name => "NoToken NewName"}
      end
      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'Update password' do
      before do
        xhr :put,
            :update,
            :id => @current_user.id,
            :user => {:current_password => @current_user.password,
                      :password => "abcdefgh",
                      :password_confirmation => "abcdefgh"}
      end
      it 'returns http 204' do
        response.response_code.should == 204
      end
      it 'returns updated user' do
        up_user = JSON.parse(response.body)['user']
        expect_user = {
          'id' => @current_user.id,
          'username' => @current_user.username,
          'email' => @current_user.email,
          'admin' => @current_user.has_role?(:admin),
          'image_url' => nil,
          'followed_team_ids' => @current_user.followed_teams,
          'followed_sport_ids'=> @current_user.followed_sports,
          'party_ids' => @current_user.parties,
          'reservation_ids' => @current_user.reservations,
          'invitation_ids' => @current_user.invitations,
          'managed_team_ids' => [],
          'managed_venue_ids' => [],
          'first_name' => nil,
          'last_name' => nil,
          'endorsing_team_ids' => @current_user.endorsing_teams,
          'user_purchased_package_ids' => [],
          'first_name' => 'Test',
          'last_name' => 'User',
          'confirmed'=>true,
          'address' => {"id"=>@current_user.address.id, "created_at"=>@current_user.address.created_at.to_i, "updated_at"=>@current_user.address.updated_at.to_i, "street1"=>nil, "street2"=>nil, "city"=>nil, "state"=>nil, "zip"=>nil, "addressable_id"=>@current_user.address.addressable_id, "addressable_type"=>@current_user.address.addressable_type, "latitude"=>nil, "longitude"=>nil},
          'follower_ids'=>[],
          'followee_ids'=>[],
          'voucher_ids'=>[],
          'created_at'=>up_user['created_at'],
          'updated_at'=>up_user['updated_at']}
        up_user.should == expect_user
      end
    end
    context 'Update fields' do
      before do
        xhr :put,
            :update,
            :id => @current_user.id,
            :user => {:username => "NewName"}
      end
      it 'returns http 204' do
        response.response_code.should == 204
      end
    end
    context "set followees" do
      before do
        xhr :put,
            :update,
            :id => @current_user.id,
            :user => {:followee_ids => [1]}
      end
      it "adds the follower" do
        assigns(:user).followees.count.should == 1
      end
      it 'returns http 204' do
        response.response_code.should == 204
      end
    end
    context "remove followees" do
      before do
        xhr :put,
            :update,
            :id => @current_user.id,
            :user => {:followee_ids => []}
      end
      it "adds the follower" do
        assigns(:user).followees.count.should == 0
      end
      it 'returns http 204' do
        response.response_code.should == 204
      end
    end
    context 'Invalid credentials wrong auth token' do
      before do
        @user = Fabricate(:user)
        request.headers['auth-token'] = 'fake_token'
        xhr :put,
            :update,
            :id => @current_user.id,
            :user => {:current_password => @current_user.password,
                      :username => "NewName"}
      end
      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'Invalid Password' do
      before do
        xhr :put,
            :update,
            :id => @current_user.id,
            :user => {:current_password => 'wrongPassword',
                      :password => 'test',
                      :password_confirmation => 'test'}
      end
      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
  end

  describe "PUT follow team" do
    context "team not favorite" do
      it "adds team to user teams" do
        expect {
          put :follow_team, id: @current_user.id, team_id: @team.id, format: :json
        }.to change(@current_user.followed_teams, :count).by(1)
      end
    end
    context "team already favorite" do
      before {
        @current_user.followed_teams = [@team]
      }
      it "does not add team" do
        expect {
          put :follow_team, id: @current_user.id, team_id: @team.id, format: :json
        }.to change(@current_user.followed_teams, :count).by(0)
      end
    end
  end

  describe "PUT unfollow team" do
    context "team is favorite" do
      before {
        @current_user.followed_teams = [@team]
      }
      it "removes user from teams" do
        expect {
          put :unfollow_team, id: @current_user.id, team_id: @team.id, format: :json
        }.to change(@current_user.followed_teams, :count).by(-1)
      end
    end
    context "team not favorite" do
      it "does not remove team" do
        expect {
          put :unfollow_team, id: @current_user.id, team_id: @team.id, format: :json
        }.to change(@current_user.followed_teams, :count).by(0)
      end
    end
  end

  describe "PUT follow sport" do
    context "sport not favorite" do
      it "adds sport to user sports" do
        expect {
          put :follow_sport, id: @current_user.id, sport_id: @sport.id, format: :json
        }.to change(@current_user.followed_sports, :count).by(1)
      end
    end
    context "sport already favorite" do
      before {
        @current_user.followed_sports = [@sport]
      }
      it "does not add sport" do
        expect {
          put :follow_sport, id: @current_user.id, sport_id: @sport.id, format: :json
        }.to change(@current_user.followed_sports, :count).by(0)
      end
    end
  end

  describe "PUT unfollow sport" do
    context "sport is favorite" do
      before {
        @current_user.followed_sports = [@sport]
      }
      it "removes user from sports" do
        expect {
          put :unfollow_sport, id: @current_user.id, sport_id: @sport.id, format: :json
        }.to change(@current_user.followed_sports, :count).by(-1)
      end
    end
    context "sport not favorite" do
      it "does not remove sport" do
        expect {
          put :unfollow_sport, id: @current_user.id, sport_id: @sport.id, format: :json
        }.to change(@current_user.followed_sports, :count).by(0)
      end
    end
  end
end
