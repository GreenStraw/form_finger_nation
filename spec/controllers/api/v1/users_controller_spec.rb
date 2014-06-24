require 'spec_helper'

describe Api::V1::UsersController do
  render_views

  let(:user) { Fabricate(:user) }
  before do
    create_new_tenant
    login(:admin)
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

  describe 'POST create' do
    context 'user failed to be created' do
      before {
        Devise.should_receive(:friendly_token).and_return('12345678')
        new_user = User.new({:email=> 'test@test.com', :password=> '12345678'})
        User.should_receive(:new).with({"email"=> new_user.email, "password"=> new_user.password}).and_return(new_user)
        new_user.should_receive(:save!).and_return(false)
        xhr :post, :create, :user => {email: 'test@test.com'}
      }

      it 'returns 422' do
        response.response_code.should == 422
      end
    end

    context "email and password user (not facebook)" do
      context 'user is created' do
        before {
          Devise.should_receive(:friendly_token).and_return('12345678')
          new_user = User.new({email: 'test@test.com', password: '12345678'})
          User.should_receive(:new).with({"email"=> new_user.email, "password"=> new_user.password}).and_return(new_user)
          new_user.should_receive(:save!).and_return(true)
          email = RegistrationMailer.welcome_email(new_user)
          RegistrationMailer.should_receive(:welcome_email).with(new_user).and_return(email)
          email.should_receive(:deliver).once
          xhr :post, :create, :user => {email: 'test@test.com'}
        }

        it 'returns 200' do
          response.response_code.should == 200
        end
      end
    end
    context "facebook user" do
      context 'user is created' do
        before {
          Devise.should_receive(:friendly_token).and_return('12345678')
          new_user = User.new({email: 'test@test.com', password: '12345678', uid: '987654321', provider: 'facebook'})
          User.should_receive(:new).and_return(new_user)
          new_user.should_receive(:save!).and_return(true)
          email = RegistrationMailer.facebook_welcome_email(new_user)
          RegistrationMailer.should_receive(:facebook_welcome_email).with(new_user).and_return(email)
          email.should_receive(:deliver).once
          xhr :post, :create, :user => {email: 'test@test.com', uid: '987654321', provider: 'facebook'}
        }

        it 'returns 200' do
          response.response_code.should == 200
        end
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
          'username' => nil,
          'email' => @current_user.email,
          'admin' => @current_user.has_role?(:admin),
          'favorite_sport_ids' => @current_user.sports,
          'favorite_team_ids'=> @current_user.teams,
          'party_ids' => @current_user.parties,
          'reservation_ids' => @current_user.reservations,
          'invitation_ids' => @current_user.invitations,
          'employer_ids' => [],
          'first_name' => nil,
          'last_name' => nil,
          'endorsing_team_ids' => @current_user.endorsing_teams,
          'managed_venue_ids' => [],
          'purchased_packages' => [],
          'first_name' => 'Test',
          'last_name' => 'User',
          'confirmed'=>true,
          'address'=>nil,
          'follower_ids'=>[],
          'followee_ids'=>[]}
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
      it 'returns updated user' do
        up_user = JSON.parse(response.body)['user']
        expect_user = {
          'id' => @current_user.id,
          'username' => "NewName",
          'email' => @current_user.email,
          'admin' => @current_user.has_role?(:admin),
          'favorite_sport_ids' => @current_user.sports,
          'favorite_team_ids'=> @current_user.teams,
          'party_ids' => @current_user.parties,
          'reservation_ids' => @current_user.reservations,
          'invitation_ids' => @current_user.invitations,
          'employer_ids' => [],
          'first_name' => nil,
          'last_name' => nil,
          'endorsing_team_ids' => @current_user.endorsing_teams,
          'managed_venue_ids' => [],
          'purchased_packages' => [],
          'first_name' => 'Test',
          'last_name' => 'User',
          'confirmed'=>true,
          'address'=>nil,
          'follower_ids'=>[],
          'followee_ids'=>[]}
        up_user.should == expect_user
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

  describe "PUT reset_password" do
    context "reset" do
      before {
        @current_password = @current_user.password
        User.should_receive(:find).and_return(@current_user)
        @current_user.should_receive(:send_password_reset).once
        xhr :put,
            :reset_password,
            :id => @current_user.id
      }
      it "should set password" do
        assigns(:user).password.should_not eq(@current_password)
      end
      it "should set confirmed false" do
        assigns(:user).confirmed_at.should be_nil
      end
    end
  end
end
