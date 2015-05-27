require 'spec_helper'

describe Api::V1::EndorsementRequestsController do

  render_views

  before do
    create_new_tenant
    login(:admin)
    @endorsement_request = Fabricate(:endorsement_request)

    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:valid_attributes) { Fabricate.attributes_for(:endorsement_request) }

  describe "GET index" do
    before(:each) do
      get :index, :format => :json
    end
    it "returns https status 200" do
      response.status.should eq(200)
    end
    it "assigns all endorsement_requests as @endorsement_requests" do
      assigns(:endorsement_requests).should_not be_nil
    end
  end

  describe "GET show" do
    it "assigns the requested activity as @endorsement_request" do
      get :show, :id => @endorsement_request.to_param, :format => :json
      assigns(:endorsement_request).should eq(@endorsement_request)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        post :create, :endorsement_request => valid_attributes, :format => :json
      end
      it "assigns a newly created endorsement_request as @endorsement_request" do
        assigns(:endorsement_request).should be_a(EndorsementRequest)
      end
      it "creates a new EndorsementRequest" do
        assigns(:endorsement_request).should be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
      it "responds with json" do
        expect(JSON.parse(response.body)).to have_key('endorsement_request')
      end
    end

    describe "with invalid params" do
      before(:each) do
        EndorsementRequest.any_instance.should_receive(:valid?).and_return(false)
        post :create, :endorsement_request => { "user_id" => "" }, :format => :json
      end
      it "assigns a newly created but unsaved activity as @endorsement_request" do
        assigns(:endorsement_request).should be_a_new(EndorsementRequest)
      end
      it "dos not persist the endorsement_request" do
        assigns(:endorsement_request).should_not be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        EndorsementRequest.any_instance.should_receive(:update)
        put :update, :id => @endorsement_request.to_param, :endorsement_request => valid_attributes, :format => :json
      end
      it "assigns the requested activity as @endorsement_request" do
        assigns(:endorsement_request).should eq(@endorsement_request)
      end
      it "responds with status 204" do
        expect(response.status).to eq(204)
      end
      it "responds with json" do
        # expect(JSON.parse(response.body)).to have_key('endorsement_request')
        response.body.should == ''
      end
    end

    describe "with invalid params" do
      before(:each) do
        EndorsementRequest.should_receive(:find).and_return(@endorsement_request)
        @endorsement_request.should_receive(:valid?).and_return(false)
        @endorsement_request.errors.add(:base, "some generic error")
        put :update, :id => @endorsement_request.to_param, :endorsement_request => { "user_id" => "" }, :format => :json
      end
      it "assigns the activity as @endorsement_request" do
        assigns(:endorsement_request).should eq(@endorsement_request)
      end
      it "should return the error as json" do
        response.body.should eq("{\"errors\":{\"base\":[\"some generic error\"]}}")
      end
    end
  end
end
