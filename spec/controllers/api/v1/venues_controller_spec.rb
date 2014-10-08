require 'spec_helper'

describe Api::V1::VenuesController do

  render_views

  before do
    create_new_tenant
    login(:admin)
    @venue = Fabricate(:venue)

    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:valid_attributes) { Fabricate.attributes_for(:venue) }

  describe "GET index" do
    context "date passed in" do
      before {
        Venue.all.map(&:destroy)
        @t1 = Fabricate(:venue, updated_at: (DateTime.now - 5.days))
        @t2 = Fabricate(:venue, updated_at: (DateTime.now - 1.days))
        get :index, format: :json, date: (DateTime.now - 3.days).to_i.to_s
      }

      it "only returns t2" do
        response.body.should eq("{\"packages\":[],\"venues\":[{\"id\":3,\"created_at\":#{@t2.created_at.to_i},\"updated_at\":#{@t2.updated_at.to_i},\"image_url\":null,\"name\":\"test_bar\",\"description\":\"it's an established venue\",\"phone\":null,\"email\":null,\"hours_sunday\":null,\"hours_monday\":null,\"hours_tuesday\":null,\"hours_wednesday\":null,\"hours_thursday\":null,\"hours_friday\":null,\"hours_saturday\":null,\"website\":null,\"address\":{\"id\":4,\"created_at\":#{@t2.address.created_at.to_i},\"updated_at\":#{@t2.address.updated_at.to_i},\"street1\":\"#{@t2.address.street1}\",\"street2\":\"St. 200\",\"city\":\"Austin\",\"state\":\"TX\",\"zip\":\"78728\",\"addressable_id\":3,\"addressable_type\":\"Venue\",\"latitude\":30.4705029,\"longitude\":-97.7996912},\"followed_team_ids\":[],\"followed_sport_ids\":[],\"party_ids\":[],\"manager_ids\":[],\"package_ids\":[]}]}")
      end
      it 'returns http 200' do
        response.response_code.should == 200
      end
    end

    context 'no date passed in' do
      before {
        get :index, format: :json
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
      it "assigns all venues as @venues" do
        assigns(:venues).should_not be_nil
      end
    end
  end

  describe "GET show" do
    it "assigns the requested activity as @venue" do
      get :show, :id => @venue.to_param, :format => :json
      assigns(:venue).should eq(@venue)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        post :create, :venue => valid_attributes, :format => :json
      end
      it "assigns a newly created venue as @venue" do
        assigns(:venue).should be_a(Venue)
      end
      it "creates a new Venue" do
        assigns(:venue).should be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
      it "responds with json" do
        expect(JSON.parse(response.body)).to have_key('venue')
      end
    end

    describe "with invalid params" do
      before(:each) do
        Venue.any_instance.should_receive(:valid?).and_return(false)
        post :create, :venue => { "user_id" => "" }, :format => :json
      end
      it "assigns a newly created but unsaved activity as @venue" do
        assigns(:venue).should be_a_new(Venue)
      end
      it "dos not persist the venue" do
        assigns(:venue).should_not be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        Venue.any_instance.should_receive(:update)
        put :update, :id => @venue.to_param, :venue => valid_attributes, :format => :json
      end
      it "assigns the requested activity as @venue" do
        assigns(:venue).should eq(@venue)
      end
      it "responds with status 204" do
        expect(response.status).to eq(204)
      end
      it "responds with json" do
        # expect(JSON.parse(response.body)).to have_key('venue')
        response.body.should == ''
      end
    end

    describe "with invalid params" do
      before(:each) do
        Venue.should_receive(:find).and_return(@venue)
        @venue.should_receive(:valid?).and_return(false)
        @venue.errors.add(:base, "some generic error")
        put :update, :id => @venue.to_param, :venue => { "user_id" => "" }, :format => :json
      end
      it "assigns the activity as @venue" do
        assigns(:venue).should eq(@venue)
      end
      it "should return the error as json" do
        response.body.should eq("{\"errors\":{\"base\":[\"some generic error\"]}}")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested activity" do
      expect {
        delete :destroy, :id => @venue.to_param, :format => :json
      }.to change(Venue, :count).by(-1)
    end
  end

  describe "GET packages" do
    before {
      @package = Fabricate(:package)
      @venue.packages << @package
      get :packages, :id => @venue.to_param, :format => :json
    }

    it "returns packages" do
      response.body.should == "{\"packages\":[{\"id\":1,\"created_at\":#{@package.created_at.to_i},\"updated_at\":#{@package.updated_at.to_i},\"image_url\":null,\"name\":\"test package\",\"description\":\"wings for 50 cents\",\"price\":\"5.0\",\"is_public\":false,\"voucher_count\":0,\"party_ids\":[],\"voucher_ids\":[],\"venue_id\":1}]}"
    end
  end

end
