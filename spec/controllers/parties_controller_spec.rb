require 'spec_helper'

describe PartiesController do

  before(:each) do
    @party = Fabricate(:party)
    @address = Fabricate(:address,  addressable: @party, street1: "12345 main street", city: "Austin", state: "TX", zip: "78748") 
  end
  
  let(:valid_attributes) { Fabricate.attributes_for(:party) }

  describe "GET index" do
    it "assigns all parties as @parties" do
      get :index, {}
      assigns(:parties).should eq([@party])
    end
  end
  
  describe "GET index with search parameter" do
    it "assigns all matching parties as @parties" do
      get :index, {:party => {:search_item => @party.name}}
      assigns(:parties).should eq([@party])
    end
  end
  
  describe "GET index with location  parameter" do
    it "assigns all matching parties as @parties" do
      get :index, {:party => {:search_location => @party.address.zip}}
      assigns(:parties).should eq([@party])
    end
  end
  
  describe "GET index with location  and search parameters" do
    it "assigns all matching parties as @parties" do
      
      get :index, {:party => {:search_item => @party.name, :search_location => @party.address.zip}}
      assigns(:parties).should eq([@party])
    end
  end

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

end
