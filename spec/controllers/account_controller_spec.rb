require 'spec_helper'

describe AccountController do
  
  before do
    create_new_tenant
    @user = Fabricate(:user)

  end


  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

  describe "POST 'update'" do
    it "updates the record and returns redirects to account page" do 
      post 'update', :user => { id: @user.id, first_name:  "a test name"}
      @user.reload
      response.should be_redirect
      response.should redirect_to account_path
      expect(@user.first_name).to eq("a test name")
    end
  end
  
  describe "POST 'update' and change password" do
    it "updates the record and returns redirects to account page" do 
      post 'update', :user => { id: @user.id, first_name:  "a test name, too", password: "a new password for me"}
      @user.reload
      response.should be_redirect
      response.should redirect_to account_path
      expect(@user.first_name).to eq("a test name, too")
    end
  end
  
  describe "POST 'update' and try to change password with invalid value" do
    it "updates the record and returns redirects to account page" do 
      post 'update', :user => { id: @user.id, first_name:  "a test name, three", password: "a new"}
      @user.reload
      response.should render_template :edit
    end
  end

end
