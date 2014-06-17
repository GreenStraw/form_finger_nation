require 'spec_helper'

describe Api::V1::ConfirmationsController do
  before(:each) do
    create_new_tenant
    @request.env["devise.mapping"] = Devise.mappings[:api_v1_user]
  end
  let(:user) { Fabricate(:user) }

  describe "GET show" do
    context "confirmation_token not given" do
      before {get :show, :confirmation_token => nil}
      it 'should return 422' do
       response.response_code.should == 422
      end
    end

    context "confiramtion_token given" do
      context "confirmation token is invalid" do
        before {@user = Fabricate(:user)}
        before {get :show, :confirmation_token => 'something wrong'}
        it "should return 422" do
          response.response_code.should == 422
        end
      end
      context "confirmation token valid" do
        before {@user = Fabricate(:user)}
        before {
          u = @user
          u.confirmed_at = DateTime.now
          u.confirmation_token = nil
          User.should_receive(:confirm_by_token).with(@user.confirmation_token).and_return(u)
          get :show, :confirmation_token => @user.confirmation_token
        }

        it "should return 200" do
          response.response_code.should == 200
        end
      end
    end
  end
end
