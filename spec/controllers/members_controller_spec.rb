require 'spec_helper'

describe MembersController do
  
  it_behaves_like 'an authenticated controller', [ :index ]
  
  before do
    create_new_tenant
    login(:admin)
    @member = FactoryGirl.create(:user)
  end
  
  let(:valid_attributes) { FactoryGirl.attributes_for(:user) }
  
  describe "GET index" do
    it "assigns all members as @members" do
      get :index, {}
      assigns(:members).should eq([@current_user, @member])
    end
    it "renders index view" do
      get :index, {}
      expect(response).to render_template('index')
    end
  end

  describe "GET show" do
    it "assigns the requested member as @member" do
      pending "not implemented"
      
      get :show, {:id => @member.to_param}
      assigns(:member).should eq(@member)
    end
  end

  describe "GET new" do
    it "assigns a new member as @member" do
      get :new, {}
      assigns(:member).should be_a_new(User)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {:user => valid_attributes }
        }.to change(User, :count).by(1)
      end
      it "assigns a newly created member as @member" do
        post :create, {:user => valid_attributes}
        assigns(:member).should be_a(User)
        assigns(:member).should be_persisted
      end
    end
    describe "with invalid params" do
      # causes redirect instead of render
      # before { User.any_instance.stub(:save).and_return(false) }
      it "assigns a newly created but unsaved member as @member" do
        post :create, {:user => {:name=>""}}
        assigns(:member).should be_a_new(User)
      end
      it "re-renders the 'new' template" do
        post :create, {:user => {:name=>""}}
        response.should render_template("new")
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested member as @member" do
      get :edit, {:id => @member.to_param}
      assigns(:member).should eq(@member)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested member" do
        User.any_instance.should_receive(:update_attributes).with({ "first_name" => "member-name" })
        put :update, {:id => @member.to_param, :user => { :first_name => "member-name" }}
      end
      it "assigns the requested member as @members" do
        put :update, {:id => @member.to_param, :user => valid_attributes}
        assigns(:member).should eq(@member)
      end
      it "redirects to the member" do
        put :update, {:id => @member.to_param, :user => valid_attributes}
        response.should redirect_to(members_path)
      end
    end
    describe "with invalid params" do
      # causes redirect instead of render
      # before { User.any_instance.should_receive(:update_attributes).and_return(false) }
      it "assigns the member as @member" do
        put :update, {:id => @member.to_param, :user => {:email=>""}}
        assigns(:member).should eq(@member)
      end
      it "re-renders the 'edit' template" do
        put :update, {:id => @member.to_param, :user => {:email=>""}}
        puts response.status
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested member" do
      pending "not implemented"

      expect {
        delete :destroy, {:id => @member.to_param}
      }.to change(User, :count).by(-1)
    end
    it "redirects to the members list" do
      pending "not implemented"

      delete :destroy, {:id => @member.to_param}
      response.should redirect_to(members_url)
    end
  end

end