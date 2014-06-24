require 'spec_helper'

describe User do

  before do
    user_params = {
      :first_name => "FirstName",
      :last_name => "LastName",
      :email => 'test_user@example.com',
      :password => 'password',
      :password_confirmation => "password"
    }
    @user = User.new(user_params)
  end

  describe "when email is not present" do
    it 'should not be valid' do
      @user.email = ""
      @user.should_not be_valid
      @user.errors[:email].should include("can't be blank")
    end
  end

  describe "when password is not present" do
    it "should not be valid" do
      @user.password = ""
      @user.should_not be_valid
      @user.errors[:password].should include("can't be blank")
    end
  end

  describe "when password and password_confirmation are not match" do
    it 'shouuld not be valid' do
      @user.password = "password", @user.password_confirmation = "wordpass"
      @user.should_not be_valid
      @user.errors[:password_confirmation].should include("doesn't match Password")
    end
  end

  describe "when password is too short" do
    it "should not e valid" do
      @user.password = "pass"
      @user.should_not be_valid
      @user.errors[:password].should include("is too short (minimum is 8 characters)")
    end
  end

  describe "full_name" do
    it "should contatenate first and last name" do
      @user.full_name.should == "FirstName LastName"
    end
  end

  describe "send_password_reset" do
    it "sends an email" do
      expect { @user.send_password_reset }.to change { ActionMailer::Base.deliveries.count }.by(1)
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
#  first_name                   :string(255)
#  last_name                    :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  role                         :string(255)
#
