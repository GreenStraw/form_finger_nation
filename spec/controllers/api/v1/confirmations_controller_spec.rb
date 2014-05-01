require 'spec_helper'

describe Api::V1::ConfirmationsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:api_v1_user]
  end
  let(:user) { Fabricate(:user) }

  describe "GET show" do
    context "confirmation_token not given" do
      before {get :show, :confirmation_token => nil}
      it 'should redirect to confirmation_error page' do
       subject.should redirect_to("/confirmation_error")
      end
    end

    context "confiramtion_token given" do
      context "confirmation token is invalid" do
        before {@user = Fabricate(:user)}
        before {get :show, :confirmation_token => 'something wrong'}
        it "should redirect to confirmation_error page" do
          subject.should redirect_to("/confirmation_error")
        end
      end
      context "confirmation token valid" do
        before {@user = Fabricate(:user)}
        before {get :show, :confirmation_token => @user.confirmation_token}
        it "should redirect to sign-in page" do
          subject.should redirect_to("/sign-in")
        end
      end
    end
  end
end
