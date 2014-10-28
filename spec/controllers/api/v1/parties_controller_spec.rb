require 'spec_helper'

describe Api::V1::PartiesController do
  before do
    create_new_tenant
    login(:admin)
    @party = Fabricate(:party)
    @package = Fabricate(:package)
    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:valid_attributes) { Fabricate.attributes_for(:party) }

  describe "search_parties(search, address, radius)" do
    it "returns empty array if none found" do
      Address.should_receive(:class_within_radius_of).with('Venue', 1, 1, 25).once.and_return([])
      subject.send(:search_parties, 1, 1, 25).should == []
    end
    it "returns parties for venues in range" do
      Address.should_receive(:class_within_radius_of).with('Venue', 1, 1, 25).once.and_return([@party.venue.address])
      subject.send(:search_parties, 1, 1, 25).should == [@party]
    end
  end

  describe "GET index" do
    before(:each) do
      get :index, :format => :json
    end
    it "returns https status 200" do
      response.status.should eq(200)
    end
    it "assigns all parties as @parties" do
      assigns(:parties).should_not be_nil
    end
  end

  describe 'GET show' do
    context 'show' do
      before do
        get :show, id: @party.id, format: :json
      end

      it 'returns http 200' do
        response.response_code.should eq(200)
      end
    end
  end

  describe 'GET by_attendee' do
    before do
      get :by_attendee, user_id: @current_user.id, format: :json
    end

    it "should return 200" do
      response.status.should eq(200)
    end
  end

  describe 'GET by_organizer' do
    before do
      get :by_organizer, user_id: @current_user.id, format: :json
    end

    it "should return 200" do
      response.status.should eq(200)
    end
  end

  describe 'GET by_user_favorites' do
    before do
      get :by_user_favorites, user_id: @current_user.id, format: :json
    end

    it "should return 200" do
      response.status.should eq(200)
    end
  end

  describe "GET search" do
    context "no radius" do
      before do
        get :search, lat: 1, lng: 1, format: :json
      end

      it "returns http 200" do
        response.response_code.should eq(200)
      end
    end

    context "radius" do
      before do
        get :search, lat: 1, lng: 1, radius: 50, format: :json
      end

      it "returns http 200" do
        response.response_code.should eq(200)
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        post :create, :party => valid_attributes, :format => :json
      end
      it "assigns a newly created party as @party" do
        assigns(:party).should be_a(Party)
      end
      it "creates a new Party" do
        assigns(:party).should be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
      it "responds with json" do
        expect(JSON.parse(response.body)).to have_key('party')
      end
      it "rsvps the current user to the party" do
        expect(current_user.reservation_ids).to include(Party.last.id)
      end
    end

    describe "with invalid params" do
      before(:each) do
        post :create, :party => { "name" => "" }, :format => :json
      end
      it "assigns a newly created but unsaved activity as @party" do
        assigns(:party).should be_a_new(Party)
      end
      it "dos not persist the party" do
        assigns(:party).should_not be_persisted
      end
      it "responds with status 422" do
        expect(response.status).to eq(422)
      end
    end

    describe "with unix scheduled_for" do
      before(:each) do
        post :create, :party => { "name" => "test","scheduled_for"=>(DateTime.now + 3.days).to_i, venue_id: Venue.first.id }, :format => :json
      end
      it "returns a 201" do
        expect(response.status).to eq(201)
      end
    end
    describe "with Datetime scheduled_for" do
      before(:each) do
        post :create, :party => { "name" => "test","scheduled_for"=>(DateTime.now + 3.days), venue_id: Venue.first.id }, :format => :json
      end
      it "returns a 201" do
        expect(response.status).to eq(201)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        # Party.any_instance.should_receive(:update)
        put :update, :id => @party.to_param, :party => valid_attributes, :format => :json
      end
      it "assigns the requested activity as @party" do
        assigns(:party).should eq(@party)
      end
      it "responds with status 204" do
        expect(response.status).to eq(204)
      end
      it "responds with json" do
        # expect(JSON.parse(response.body)).to have_key('party')
        response.body.should == ''
      end
    end

    describe "with invalid params" do
      before(:each) do
        Party.should_receive(:find).and_return(@party)
        @party.should_receive(:valid?).and_return(false)
        @party.errors.add(:base, "some generic error")
        put :update, :id => @party.id, :party => { "venue_id" => "" }, :format => :json
      end
      it "assigns the activity as @party" do
        assigns(:party).should eq(@party)
      end
      it "should return the error as json" do
        response.body.should eq("{\"errors\":{\"base\":[\"some generic error\"]}}")
      end
    end
  end
  describe "DELETE destroy" do
    it "destroys the requested activity" do
      expect {
        delete :destroy, :id => @party.id, :format => :json
      }.to change(Party, :count).by(-1)
    end
  end

  describe "PUT rsvp" do
    context 'user not authenticated' do
      before {
        request.headers['auth-token'] = 'fake_authentication_token'
        xhr :put, :rsvp, id: @party.id, user_id: @current_user.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'user authenticated' do
      context 'party attendees does not include user' do
        before {
          @party.attendees.clear
          @party.attendees.should_not include(@current_user)
          xhr :put, :rsvp, id: @party.id, user_id: @current_user.id
        }

        it 'should add the attendee to party' do
          assigns(:party).attendees.should include(@current_user)
        end

        it 'returns http 204' do
          response.response_code.should == 204
        end
      end
      context 'party attendees does include user' do
        before {
          @party.attendees.clear
          @party.attendees.should_not_receive(:<<)
          xhr :put, :rsvp, id: @party.id, user_id: @current_user.id
        }

        it 'returns http 204' do
          response.response_code.should == 204
        end
      end
    end
  end

  describe "PUT unrsvp" do
    context 'user not authenticated' do
      before {
        request.headers['auth-token'] = 'fake_authentication_token'
        xhr :put, :unrsvp, id: @party.id, user_id: @current_user.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'user authenticated' do
      context 'party attendees include user' do
        before {
          @party.attendees.clear
          @party.attendees << @current_user
          @party.attendees.should include(@current_user)
          xhr :put, :unrsvp, id: @party.id, user_id: @current_user.id
        }

        it 'should add the attendee to party' do
          assigns(:party).attendees.should_not include(@current_user)
        end

        it 'returns http 204' do
          response.response_code.should == 204
        end
      end
      context 'party attendees does not include user' do
        before {
          @party.attendees.clear
          @party.attendees.should_not_receive(:delete)
          xhr :put, :unrsvp, id: @party.id, user_id: @current_user.id
        }

        it 'returns http 204' do
          response.response_code.should == 204
        end
      end
    end
  end

  describe "invite" do
    before(:each) do
      @party.update_attribute(:organizer, @current_user)
      Party.should_receive(:find).and_return(@party)
      post :invite, id: 1, emails:['test2@test.com'], :format => :json
    end
    it "responds with status 201" do
      expect(response.status).to eq(201)
    end
    it "responds with json" do
      expect(JSON.parse(response.body)).to have_key('party')
    end

    context "user is invited by id" do
      before(:each) do
        @party.update_attribute(:organizer, @current_user)
      end
      it "passes the correct invitees to PartyInvitation.create_invitations" do
        u = User.create(email: 'test2@test.com')
        PartyInvitation.should_receive(:send_invitations).with(['test2@test.com','test3@test.com'] ,@party.organizer_id, @party.id)
        post :invite, id: 1, emails:['test2@test.com','test3@test.com'], :format => :json
      end
    end
  end

  describe "PUT add_package" do
    context "user not fan" do
      it "adds user to party packages" do
        expect {
          put :add_package, id: @party.id, package_id: @package.id, format: :json
        }.to change(@party.packages, :count).by(1)
      end
    end
    context "user already fan" do
      before {
        @party.packages = [@package]
      }
      it "does not add user" do
        expect {
          put :add_package, id: @party.id, package_id: @package.id, format: :json
        }.to change(@party.packages, :count).by(0)
      end
    end
  end

  describe "PUT remove_package" do
    context "user is fan" do
      before {
        @party.packages = [@package]
      }
      it "removes user from party packages" do
        expect {
          put :remove_package, id: @party.id, package_id: @package.id, format: :json
        }.to change(@party.packages, :count).by(-1)
      end
    end
    context "user not fan" do
      it "does not remove user" do
        expect {
          put :remove_package, id: @party.id, package_id: @package.id, format: :json
        }.to change(@party.packages, :count).by(0)
      end
    end
  end
end
