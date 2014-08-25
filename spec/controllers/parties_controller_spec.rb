require 'spec_helper'

describe PartiesController do

  before(:each) do
    login(:admin)
    @party = Fabricate(:party)
    @address = Fabricate(:address,  addressable: @party, street1: "12345 main street", city: "Austin", state: "TX", zip: "78748") 
  end
  
  let(:valid_attributes) { Fabricate.attributes_for(:party) }



  describe "GET show" do
    it "assigns the requested party as @party" do
      get :show, {:id => @party.to_param}
      assigns(:party).should eq(@party)
    end
  end

  describe "GET new" do
    it "assigns a new party as @party" do
      get :new, {}
      assigns(:party).should be_a_new(Party)
    end
  end

  describe "GET edit" do
    it "assigns the requested party as @party" do
      get :edit, {:id => @party.to_param}
      assigns(:party).should eq(@party)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Party" do
        expect {
          post :create, {:party => valid_attributes}
        }.to change(Party, :count).by(1)
      end

      it "assigns a newly created party as @party" do
        post :create, {:party => valid_attributes}
        assigns(:party).should be_a(Party)
        assigns(:party).should be_persisted
      end

      it "redirects to the created party" do
        post :create, {:party => valid_attributes}
        response.should redirect_to(Party.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved party as @party" do
        # Trigger the behavior that occurs when invalid params are submitted
        Party.any_instance.stub(:save).and_return(false)
        post :create, {:party => { "name" => "" }}
        assigns(:party).should be_a_new(Party)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Party.any_instance.stub(:save).and_return(false)
        post :create, {:party => { "name" => "" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested party" do
        # Assuming there are no other parties in the database, this
        # specifies that the Party created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Party.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => @party.to_param, :party => { "name" => "MyString" }}
      end

      it "assigns the requested party as @party" do
        put :update, {:id => @party.to_param, :party => valid_attributes}
        assigns(:party).should eq(@party)
      end

      it "redirects to the party" do
        put :update, {:id => @party.to_param, :party => valid_attributes}
        response.should redirect_to(@party)
      end
    end

    describe "with invalid params" do
      it "assigns the party as @party" do
        # Trigger the behavior that occurs when invalid params are submitted
        Party.any_instance.stub(:save).and_return(false)
        put :update, {:id => @party.to_param, :party => { "name" => "" }}
        assigns(:party).should eq(@party)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Party.any_instance.stub(:save).and_return(false)
        put :update, {:id => @party.to_param, :party => { "name" => "" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested party" do
      expect {
        delete :destroy, {:id => @party.to_param}
      }.to change(Party, :count).by(-1)
    end

    it "redirects to the parties list" do
      delete :destroy, {:id => @party.to_param}
      response.should redirect_to(parties_url)
    end
  end
  
  describe "party RSVP" do
    it "RSVPs the requested party" do
      expect {
        get :party_rsvp, {:id => @party.to_param}
      }.to change(PartyReservation, :count).by(1)
    end
    
    it "unRSVPs the requested party" do
      #create the RSVP so it can be removed
      get :party_rsvp, {:id => @party.to_param}
      expect {
        get :party_rsvp, {:id => @party.to_param}
      }.to change(PartyReservation, :count).by(-1)
    end

    it "redirects to party/show" do
      get :party_rsvp, {:id => @party.to_param}
      response.should redirect_to(party_url(@party.id))
    end
  end
  

  describe "send invites " do
    it "Increments the number of invites to the requested party" do
      expect {
        post :send_invites, {:id => @party.to_param, invites: {email: "test@user.com"}}
      }.to change(PartyInvitation, :count).by(1)
    end
    
    it "will not increment the invites count for an email that has already been invited" do
      #create the invite so it should not be created again
      post :send_invites, {:id => @party.to_param, invites: {email: "test@user.com"}}
      expect {
        post :send_invites, {:id => @party.to_param, invites: {email: "test@user.com"}}
      }.to change(PartyInvitation, :count).by(0)
    end
    
    it "will not increment the counter when an invalid email address is submitted" do
      expect {
        post :send_invites, {:id => @party.to_param, invites: {email: "user.com"}}
      }.to change(PartyInvitation, :count).by(0)
    end
    
    it "redirects to party/show" do
      get :party_rsvp, {:id => @party.to_param}
      response.should redirect_to(party_url(@party.id))
    end
  end
 
  describe "send invites stub" do
    it "redirects to party/show" do
      Party.any_instance.should_receive(:handle_invites).with({"invites"=>{"email"=>"test@user.com"}, "id"=>@party.id.to_s,  "controller"=>"parties", "action"=>"send_invites"}, current_user)
      post :send_invites, {:id => @party.to_param, :invites => {:email => "test@user.com"}}
      response.should redirect_to(@party)  
    end
  end

    

end
