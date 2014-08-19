require 'spec_helper'

describe User do

  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should validate_presence_of :email }

  before do
    @user = Fabricate(:user)
  end

  describe 'confirm!' do
    it 'sets confirmed_at' do
      @user.confirmed_at = nil
      @user.confirm!
      expect(@user.confirmed_at).to_not be_nil
    end
  end

  describe 'confirmed?' do
    context 'when user has not been confirmed' do
      it 'returns false' do
        @user.confirmed_at = nil
        expect(@user.confirmed?).to eq(false)
      end
    end
    context 'when user has been confirmed' do
      it 'returns true' do
        expect(@user.confirmed?).to eq(true)
      end
    end
  end

  describe "full_name" do
    it "should contatenate first and last name" do
      @user.full_name.should == "#{@user.first_name} #{@user.last_name}"
    end
  end

  describe 'ability' do
    it 'returns Ability instance' do
      expect(@user.ability.class).to eq(Ability)
    end
  end

  describe 'data' do
    it 'returns a hash' do
      expect(@user.data.class).to eq(Hash)
    end
  end

  describe 'managed_teams' do
    context 'no managed team' do
      before {
        @team = Fabricate(:team)
      }

      it "should return team" do
        expect(@user.managed_teams).to eq([])
      end
    end
    context 'one managed team' do
      before {
        @team = Fabricate(:team)
        @user.add_role(:team_admin, @team)
      }

      it "should return team" do
        expect(@user.managed_teams).to eq([@team])
      end
    end
    context 'user is admin' do
      before {
        @team = Fabricate(:team)
        @user.add_role(:admin)
      }

      it "should return team" do
        expect(@user.managed_teams).to eq([@team])
      end
    end
  end

  describe 'managed_teams' do
    context 'no managed venue' do
      before {
        @venue = Fabricate(:venue)
      }

      it "should return venue" do
        expect(@user.managed_venues).to eq([])
      end
    end
    context 'one managed venue' do
      before {
        @venue = Fabricate(:venue)
        @user.add_role(:manager, @venue)
      }

      it "should return venue" do
        expect(@user.managed_venues).to eq([@venue])
      end
    end
    context 'user is admin' do
      before {
        @venue = Fabricate(:venue)
        @user.add_role(:admin)
      }

      it "should return venue" do
        expect(@user.managed_venues).to eq([@venue])
      end
    end
  end

  describe 'User.first_user_by_facebook_id' do
    context "With a real token first_user_by_facebook_id" do
      it "should return a user" do
        Koala::Facebook::API.should_receive(:new).with("access_token").and_return(@user)
        @user.should_receive(:get_object).with("me").and_return(@user)
        User.should_receive(:where).with(uid: @user.id).and_return([@user])
        User.first_user_by_facebook_id("access_token").should == @user
      end
    end
    context "With a fake token first_user_by_facebook_id" do
      it "should return nil" do
        User.first_user_by_facebook_id("fake_token").should == nil
      end
    end
  end

  describe 'User.new_with_session' do
    context 'when devise.user_attributes exists in session' do
      it 'returns a new user populated with session date' do
        params = Fabricate.attributes_for(:user)
        sess = { "devise.user_attributes" => params }
        expect(User.new_with_session(params, sess).class).to eq(User)
      end
    end
    context 'when devise.user_attributes does not exist in session' do
      it 'returns a new user' do
        expect(User.new_with_session(nil, {}).class).to eq(User)
      end
    end
  end

  describe 'User.from_omniauth' do
    describe "when auth is nil" do
      it "should return nil" do
        User.from_omniauth(nil, nil).should == nil
      end
    end
    describe 'when auth is not nil' do
      context 'when user record exists' do
        it "return the user" do
          creds = double(:creds, :token => 'token', :secret => 'secret')
          @auth = double(:auth, :provider => 'provider', :uid => 'uid', :credentials=>creds)
          authorization = double(:authorization, :user=>@user)
          authorization.should_receive(:first_or_initialize).and_return(authorization)
          Authorization.should_receive(:where).with({:provider=>'provider', :uid=>'uid', :token=>'token', :secret=>'secret'}).and_return(authorization)
          expect(User.from_omniauth(@auth, @user).class).to eq(User)
        end
      end
      context 'when user record does not exist' do
        it "return nil" do
          creds = double(:creds, :token => 'token', :secret => 'secret')
          info = double(:info, :name=>'user', :email=>'user@domain.com', :nickname=>'bob')
          @auth = double(:auth, :provider => 'provider', :uid => 'uid', :credentials=>creds, 'info'=>info)
          authorization = double(:authorization, :user=>nil)
          authorization.should_receive(:first_or_initialize).and_return(authorization)
          authorization.should_receive(:username=).with('bob').and_return(authorization)
          authorization.should_receive(:user_id=).with(2).and_return(authorization)
          authorization.should_receive(:save).and_return(true)
          Authorization.should_receive(:where).with({:provider=>'provider', :uid=>'uid', :token=>'token', :secret=>'secret'}).and_return(authorization)
          expect(User.from_omniauth(@auth, nil).class).to eq(NilClass)
        end
      end
    end
  end

  describe 'User.find_by_authentication_token' do
    context 'when authentication_token is nil' do
      it 'returns nil' do
        expect(User.find_by_authentication_token(nil)).to eq(nil)
      end
    end
    context 'when authentication_token exists' do
      it 'returns user' do
        @user.authentication_token = 'toe_kin'
        @user.save!
        expect(User.find_by_authentication_token('toe_kin')).to eq(@user)
      end
    end
  end

end

# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  email                        :string(255)      default(""), not null
#  encrypted_password           :string(255)      default(""), not null
#  reset_password_token         :string(255)
#  reset_password_sent_at       :datetime
#  remember_created_at          :datetime
#  sign_in_count                :integer          default(0), not null
#  current_sign_in_at           :datetime
#  last_sign_in_at              :datetime
#  current_sign_in_ip           :string(255)
#  last_sign_in_ip              :string(255)
#  confirmation_token           :string(255)
#  confirmed_at                 :datetime
#  confirmation_sent_at         :datetime
#  unconfirmed_email            :string(255)
#  failed_attempts              :integer          default(0), not null
#  unlock_token                 :string(255)
#  locked_at                    :datetime
#  skip_confirm_change_password :boolean          default(FALSE)
#  tenant_id                    :integer
#  authentication_token         :string(255)
#  first_name                   :string(255)
#  last_name                    :string(255)
#  role                         :string(255)
#  username                     :string(255)
#  provider                     :string(255)
#  uid                          :string(255)
#  customer_id                  :string(255)
#  facebook_access_token        :string(255)
#  image_url                    :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  name                         :string(255)
#
