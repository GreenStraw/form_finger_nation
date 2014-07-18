require 'spec_helper'

describe Api::V1::SportsController do
  render_views

  before do
    create_new_tenant
    login(:admin)
    @sport = Fabricate(:sport)

    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:valid_attributes) { Fabricate.attributes_for(:sport) }

  describe "GET index" do
    before(:each) do
      get :index, format: :json
    end
    it "returns https status 200" do
      response.status.should eq(200)
    end
    it "assigns all sports as @sports" do
      assigns(:sports).should_not be_nil
    end
  end

  describe "GET show" do
    it "assigns the requested activity as @sport" do
      get :show, :id => @sport.to_param, format: :json
      assigns(:sport).should eq(@sport)
    end
  end

  describe "POST create" do
    describe "with invalid authentication" do
      before(:each) do
        request.headers['auth-token'] = 'fake_authentication_token'
        post :create, :sport => valid_attributes, format: :json
      end
      it "returns http status 401" do
        response.status.should eq(401)
      end
    end
    describe "with valid params" do
      before(:each) do
        post :create, :sport => valid_attributes, format: :json
      end
      it "assigns a newly created sport as @sport" do
        assigns(:sport).should be_a(Sport)
      end
      it "creates a new Sport" do
        assigns(:sport).should be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
      it "responds with json" do
        expect(JSON.parse(response.body)).to have_key('sport')
      end
    end

    describe "with invalid params" do
      before(:each) do
        Sport.any_instance.should_receive(:valid?).and_return(false)
        post :create, :sport => { "user_id" => "" }, format: :json
      end
      it "assigns a newly created but unsaved activity as @sport" do
        assigns(:sport).should be_a_new(Sport)
      end
      it "dos not persist the sport" do
        assigns(:sport).should_not be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        Sport.any_instance.should_receive(:update)
        put :update, :id => @sport.to_param, :sport => valid_attributes, format: :json
      end
      it "assigns the requested activity as @sport" do
        assigns(:sport).should eq(@sport)
      end
      it "responds with status 204" do
        expect(response.status).to eq(204)
      end
      it "responds with json" do
        # expect(JSON.parse(response.body)).to have_key('sport')
        response.body.should == ''
      end
    end

    describe "with invalid params" do
      before(:each) do
        Sport.should_receive(:find).and_return(@sport)
        @sport.should_receive(:valid?).and_return(false)
        @sport.errors.add(:base, "some generic error")
        put :update, :id => @sport.to_param, :sport => { "name" => "" }, format: :json
      end
      it "assigns the activity as @sport" do
        assigns(:sport).should eq(@sport)
      end
      it "responds with status 422" do
        expect(response.status).to eq(422)
      end
      it "should return the error as json" do
        response.body.should eq("{\"errors\":{\"base\":[\"some generic error\"]}}")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested activity" do
      expect {
        delete :destroy, :id => @sport.to_param, format: :json
      }.to change(Sport, :count).by(-1)
    end
  end
end
