require 'spec_helper'

describe Api::V1::AddressesController do
  render_views

  before do
    create_new_tenant
    login(:admin)
    @address = Fabricate(:address)
    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:valid_attributes) { Fabricate.attributes_for(:address) }

  describe 'GET index' do
    context 'index' do
      before do
        get :index, format: :json
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
      it "assigns all parties as @addresses" do
        assigns(:addresses).should_not be_nil
      end
    end
  end

  describe 'GET show' do
    context 'show' do
      before do
        get :show, id: @address.id, format: :json
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        post :create, :address => valid_attributes, format: :json
      end
      it "assigns a newly created address as @address" do
        assigns(:address).should be_a(Address)
      end
      it "creates a new Address" do
        assigns(:address).should be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
      it "responds with json" do
        expect(JSON.parse(response.body)).to have_key('street1')
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        Address.any_instance.should_receive(:update)
        put :update, :id => @address.to_param, :address => valid_attributes, :format => :json
      end
      it "assigns the requested activity as @address" do
        assigns(:address).should eq(@address)
      end
      it "responds with status 204" do
        expect(response.status).to eq(204)
      end
      it "responds with json" do
        # expect(JSON.parse(response.body)).to have_key('address')
        response.body.should == ''
      end
    end

    describe "with invalid params" do
      before(:each) do
        Address.should_receive(:find).and_return(@address)
        @address.should_receive(:valid?).and_return(false)
        @address.errors.add(:base, "some generic error")
        put :update, :id => @address.to_param, :address => { "name" => "" }, :format => :json
      end
      it "assigns the activity as @address" do
        assigns(:address).should eq(@address)
      end
      it "responds with status 422" do
        expect(response.status).to eq(422)
      end
      it "should return the error as json" do
        response.body.should eq("{\"errors\":{\"base\":[\"some generic error\"]}}")
      end
    end
  end
end
