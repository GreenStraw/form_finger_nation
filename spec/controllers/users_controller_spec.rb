require 'spec_helper'

describe UsersController do

  before(:each) do
    create_new_tenant
    login(:admin)
    @user = Fabricate(:user)
  end

  describe "PUT add_admin" do
    context "user not admin" do
      before {
        @user.roles.clear
      }
      it "give user admin role" do
        expect {
          put :add_admin, user_id: @user.id, format: :js
        }.to change(User.admins, :count).by(1)
      end
    end
    context "user already admin" do
      before {
        @user.add_role(:admin)
      }
      it "does not add user" do
        expect {
          put :add_admin, user_id: @user.id, format: :js
        }.to change(User.admins, :count).by(0)
      end
    end
  end

  describe "PUT remove_admin" do
    context "user admin" do
      before {
        @user.add_role(:admin)
      }
      it "remove user admin role" do
        expect {
          put :remove_admin, user_id: @user.id, format: :js
        }.to change(User.admins, :count).by(-1)
      end
    end
    context "user not admin" do
      before {
        @user.roles.clear
      }
      it "does not remove admin role" do
        expect {
          put :remove_admin, user_id: @user.id, format: :js
        }.to change(User.admins, :count).by(0)
      end
    end
  end
end
