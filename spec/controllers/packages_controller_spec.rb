require 'spec_helper'

describe PackagesController do

  before(:each) do
    @package = Fabricate(:package)
  end
  
  let(:valid_attributes) { Fabricate.attributes_for(:package) }

  describe "GET index" do
    it "assigns all packages as @packages" do
      get :index, {}
      assigns(:packages).should eq([@package])
    end
  end

  describe "GET show" do
    it "assigns the requested package as @package" do
      get :show, {:id => @package.to_param}
      assigns(:package).should eq(@package)
    end
  end

  describe "GET new" do
    it "assigns a new package as @package" do
      get :new, {}
      assigns(:package).should be_a_new(Package)
    end
  end

  describe "GET edit" do
    it "assigns the requested package as @package" do
      get :edit, {:id => @package.to_param}
      assigns(:package).should eq(@package)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Package" do
        expect {
          post :create, {:package => valid_attributes}
        }.to change(Package, :count).by(1)
      end

      it "assigns a newly created package as @package" do
        post :create, {:package => valid_attributes}
        assigns(:package).should be_a(Package)
        assigns(:package).should be_persisted
      end

      it "redirects to the created package" do
        post :create, {:package => valid_attributes}
        response.should redirect_to(Package.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved package as @package" do
        # Trigger the behavior that occurs when invalid params are submitted
        Package.any_instance.stub(:save).and_return(false)
        post :create, {:package => { "name" => "" }}
        assigns(:package).should be_a_new(Package)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Package.any_instance.stub(:save).and_return(false)
        post :create, {:package => { "name" => "" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested package" do
        # Assuming there are no other packages in the database, this
        # specifies that the Package created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Package.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => @package.to_param, :package => { "name" => "MyString" }}
      end

      it "assigns the requested package as @package" do
        put :update, {:id => @package.to_param, :package => valid_attributes}
        assigns(:package).should eq(@package)
      end

      it "redirects to the package" do
        put :update, {:id => @package.to_param, :package => valid_attributes}
        response.should redirect_to(@package)
      end
    end

    describe "with invalid params" do
      it "assigns the package as @package" do
        # Trigger the behavior that occurs when invalid params are submitted
        Package.any_instance.stub(:save).and_return(false)
        put :update, {:id => @package.to_param, :package => { "name" => "" }}
        assigns(:package).should eq(@package)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Package.any_instance.stub(:save).and_return(false)
        put :update, {:id => @package.to_param, :package => { "name" => "" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested package" do
      expect {
        delete :destroy, {:id => @package.to_param}
      }.to change(Package, :count).by(-1)
    end

    it "redirects to the packages list" do
      delete :destroy, {:id => @package.to_param}
      response.should redirect_to(packages_url)
    end
  end

end
