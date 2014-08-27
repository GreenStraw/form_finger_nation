require 'spec_helper'

describe PackagesController do

  before(:each) do
    create_new_tenant
    login(:admin)
    @package = Fabricate(:package)
    @venue = Fabricate(:venue)
    @party = Fabricate(:party)
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
      get :new, {venue_id: @venue.id}
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
          post :create, {:package => valid_attributes, venue_id: valid_attributes[:venue_id]}
        }.to change(Package, :count).by(1)
      end

      it "assigns a newly created package as @package" do
        post :create, {:package => valid_attributes, venue_id: valid_attributes[:venue_id]}
        assigns(:package).should be_a(Package)
        assigns(:package).should be_persisted
      end

      it "redirects to the created package" do
        post :create, {:package => valid_attributes, venue_id: valid_attributes[:venue_id]}
        response.should redirect_to(edit_venue_path(valid_attributes[:venue_id]))
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
  end

  describe "DELETE destroy" do
    it "destroys the requested package" do
      expect {
        delete :destroy, {:id => @package.to_param}
      }.to change(Package, :count).by(-1)
    end

    it "redirects to the packages list" do
      delete :destroy, {:id => @package.to_param}
      response.should redirect_to(edit_venue_path(@package.venue))
    end
  end

  describe "PUT assign" do
    context "user not host" do
      it "adds package to party" do
        expect {
          put :assign, id: @package.id, party_id: @party.id, format: :js
        }.to change(@package.parties, :count).by(1)
      end
    end
    context "user already host" do
      before {
        @package.parties = [@party]
      }
      it "does not add user" do
        expect {
          put :assign, id: @package.id, party_id: @party.id, format: :js
        }.to change(@package.parties, :count).by(0)
      end
    end
  end

  describe "PUT unassign" do
    context "user is host" do
      before {
        @package.parties = [@party]
      }
      it "removes package from party" do
        expect {
          put :unassign, id: @package.id, party_id: @party.id, format: :js
        }.to change(@package.parties, :count).by(-1)
      end
    end
    context "user not host" do
      it "does not remove user" do
        expect {
          put :unassign, id: @package.id, party_id: @party.id, format: :js
        }.to change(@package.parties, :count).by(0)
      end
    end
  end

end
