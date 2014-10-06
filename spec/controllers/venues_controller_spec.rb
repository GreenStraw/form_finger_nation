require 'spec_helper'

describe VenuesController do

  before(:each) do
    create_new_tenant
    login(:admin)
    @venue = Fabricate(:venue)
  end

  let(:valid_attributes) { Fabricate.attributes_for(:venue) }

  describe "GET index" do
    it "assigns all venues as @venues" do
      get :index, {}
      assigns(:venues).should eq([@venue])
    end
  end

  describe "GET show" do
    it "assigns the requested venue as @venue" do
      get :show, {:id => @venue.to_param}
      assigns(:venue).should eq(@venue)
    end
  end

  describe "GET new" do
    it "assigns a new venue as @venue" do
      get :new, {}
      assigns(:venue).should be_a_new(Venue)
    end
  end

  describe "GET edit" do
    it "assigns the requested venue as @venue" do
      get :edit, {:id => @venue.to_param}
      assigns(:venue).should eq(@venue)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before {
        @venue_attributes = {:name => "Venue", :description => 'test', :address_attributes => {:city => "Florence", :state => "Alabama", :street1 => "123 Monroe St."}}
      }
      it "creates a new Venue" do
        expect {
          post :create, {:venue => @venue_attributes}
        }.to change(Venue, :count).by(1)
      end

      it "assigns a newly created venue as @venue" do
        post :create, {:venue => @venue_attributes}
        assigns(:venue).should be_persisted
      end

      it "redirects to the created venue" do
        post :create, {:venue => @venue_attributes}
        response.should redirect_to(Venue.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved venue as @venue" do
        # Trigger the behavior that occurs when invalid params are submitted
        Venue.any_instance.stub(:save).and_return(false)
        post :create, {:venue => { "name" => "invalid value" }}
        assigns(:venue).should be_a_new(Venue)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Venue.any_instance.stub(:save).and_return(false)
        post :create, {:venue => { "name" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested venue" do
        # Assuming there are no other venues in the database, this
        # specifies that the Venue created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Venue.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => @venue.to_param, :venue => { "name" => "MyString" }}
      end

      it "assigns the requested venue as @venue" do
        put :update, {:id => @venue.to_param, :venue => valid_attributes}
        assigns(:venue).should eq(@venue)
      end

      it "redirects to the venue" do
        put :update, {:id => @venue.to_param, :venue => valid_attributes}
        response.should redirect_to(@venue)
      end
    end

    describe "with invalid params" do
      it "assigns the venue as @venue" do
        # Trigger the behavior that occurs when invalid params are submitted
        Venue.any_instance.stub(:save).and_return(false)
        put :update, {:id => @venue.to_param, :venue => { "name" => "invalid value" }}
        assigns(:venue).should eq(@venue)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Venue.any_instance.stub(:save).and_return(false)
        put :update, {:id => @venue.to_param, :venue => { "name" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested venue" do
      expect {
        delete :destroy, {:id => @venue.to_param}
      }.to change(Venue, :count).by(-1)
    end

    it "redirects to the venues list" do
      delete :destroy, {:id => @venue.to_param}
      response.should redirect_to(venues_url)
    end
  end

  describe "PUT add_manager" do
    context "user not manager" do
      it "give user venue manager role" do
        expect {
          put :add_manager, id: @venue.id, user_id: current_user.id, format: :js
        }.to change(@venue.managers, :count).by(1)
      end
    end
    context "user already fan" do
      before {
        current_user.add_role(:venue_manager, @venue)
      }
      it "does not add user" do
        expect {
          put :add_manager, id: @venue.id, user_id: current_user.id, format: :js
        }.to change(@venue.managers, :count).by(0)
      end
    end
  end

  describe "PUT remove_manager" do
    context "user manager" do
      before {
        current_user.add_role(:venue_manager, @venue)
      }
      it "remove user venue manager role" do
        expect {
          put :remove_manager, id: @venue.id, user_id: current_user.id, format: :js
        }.to change(@venue.managers, :count).by(-1)
      end
    end
    context "user not manager" do
      it "does not remove user role" do
        expect {
          put :remove_manager, id: @venue.id, user_id: current_user.id, format: :js
        }.to change(@venue.managers, :count).by(0)
      end
    end
  end

  describe "PUT verify_party" do
    context "venue party not verified" do
      before {
        @party = Fabricate(:party, verified: false)
      }
      it "verifies party" do
        put :verify_party, id: @venue.id, party_id: @party.id, format: :js
        assigns(:party).verified.should eq(true)
      end
    end
  end

  describe "PUT unverify_party" do
    context "venue party verified" do
      before {
        @party = Fabricate(:party, verified: true)
      }
      it "unverifies party" do
        put :unverify_party, id: @venue.id, party_id: @party.id, format: :js
        assigns(:party).verified.should eq(false)
      end
    end
  end
end
