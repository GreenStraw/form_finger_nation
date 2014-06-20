require 'spec_helper'

describe Api::V1::PartiesController do
  before do
    create_new_tenant
    login(:admin)
    @party = Fabricate(:party)
    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:valid_attributes) { Fabricate.attributes_for(:party) }

  describe "search_parties(search, address, radius)" do
    before(:each) do
      Venue.all.map(&:destroy)
      Party.all.map(&:destroy)
      @e1 = Venue.create(name: 'Bar 1', address: Fabricate(:address))
      @e2 = Venue.create(name: 'Bar 2', address: Fabricate(:address))
      @t = Team.create(name: 'Team 1')
      @p1 = Party.create(venue: @e1, name: 'Party 1', team: @t, scheduled_for: DateTime.now + 1.day, is_private: false)
      @p2 = Party.create(venue: @e2, name: 'Party 2', team: @t, scheduled_for: DateTime.now + 8.days, is_private: false)
    end
    it "should call venue_ids_by_address_and_radius" do
      subject.should_receive(:venue_ids_by_address_and_radius).with('78728', 15).and_return([@e1.id]);
      subject.send(:search_parties, '', '78728', 15, Date.today, Date.today + 7.days)
    end

    it "should return parties in the area if there are any" do
      subject.should_receive(:venue_ids_by_address_and_radius).with('78728', 15).and_return([@e1.id]);
      subject.send(:search_parties, '', '78728', 15, Date.today, Date.today + 7.days).should == [@p1]
    end

    it "should not find parties in the area if there are none" do
      subject.should_receive(:venue_ids_by_address_and_radius).with('77777', 15).and_return([]);
      subject.send(:search_parties, '', '77777', 15, Date.today, Date.today + 7.days).should == []
    end

    it "should find parties by party name in area" do
      subject.should_receive(:venue_ids_by_address_and_radius).with('78728', 15).and_return([@e1.id]);
      subject.send(:search_parties, 'Party 1', '78728', 15, Date.today, Date.today + 7.days).should == [@p1]
    end

    it "should find parties by team name in area" do
      subject.should_receive(:venue_ids_by_address_and_radius).with('78728', 15).and_return([@e1.id]);
      subject.send(:search_parties, 'Team 1', '78728', 15, Date.today, Date.today + 7.days).should == [@p1]
    end

    it "should find parties by venue name in area" do
      subject.should_receive(:venue_ids_by_address_and_radius).with('78728', 15).and_return([@e1.id]);
      subject.send(:search_parties, 'Bar 1', '78728', 15, Date.today, Date.today + 7.days).should == [@p1]
    end

    it "should find no parties if outside of date range" do
      subject.should_receive(:venue_ids_by_address_and_radius).with('79424', 15).and_return([@e2.id]);
      subject.send(:search_parties, '', '79424', 15, Date.today, Date.today + 7.days).should == []
    end

    it "should find  parties if inside of date range" do
      subject.should_receive(:venue_ids_by_address_and_radius).with('79424', 15).and_return([@e2.id]);
      subject.send(:search_parties, '', '79424', 15, Date.today, Date.today + 9.days).should == [@p2]
    end

    it "should not include private parties" do
      subject.should_receive(:venue_ids_by_address_and_radius).with('79424', 15).and_return([@e2.id]);
      @p2.update_attribute(:is_private, true)
      subject.send(:search_parties, '', '79424', 15, Date.today, Date.today + 9.days).should == []
    end
  end

  describe "venue_ids_by_address_and_radius(address, radius)" do
    it "should call the needed methods" do
      @v = Fabricate(:venue)
      @ad1 = Fabricate(:address)
      @ad1.should_receive(:addressable_id).and_return(@v.id)
      Address.should_receive(:near).with('1 some street', 10).and_return([@ad1])
      subject.send(:venue_ids_by_address_and_radius, '1 some street', 10).should == [@v.id]
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
      context 'current_user does not equal passed in user' do
        before {
          party = Fabricate(:party)
          other_user = Fabricate(:user)
          xhr :put, :rsvp, id: party.id, user_id: other_user.id
        }

        it 'returns http 403' do
          response.response_code.should == 403
        end
      end
      context 'current_user equals passed in user' do
        context 'party attendees does not include user' do
          before {
            party = Fabricate(:party)
            party.attendees.clear
            party.attendees.should_not include(@current_user)
            xhr :put, :rsvp, id: party.id, user_id: @current_user.id
          }

          it 'should add the attendee to party' do
            assigns(:party).attendees.should include(@current_user)
          end

          it 'returns http 200' do
            response.response_code.should == 200
          end
        end
        context 'party attendees does include user' do
          before {
            party = Fabricate(:party)
            party.attendees.clear
            party.attendees.should_not_receive(:<<)
            xhr :put, :rsvp, id: party.id, user_id: @current_user.id
          }

          it 'returns http 200' do
            response.response_code.should == 200
          end
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
      context 'current_user does not equal passed in user' do
        before {
          other_user = Fabricate(:user)
          xhr :put, :unrsvp, id: @party.id, user_id: other_user.id
        }

        it 'returns http 403' do
          response.response_code.should == 403
        end
      end
      context 'current_user equals passed in user' do
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

          it 'returns http 200' do
            response.response_code.should == 200
          end
        end
        context 'party attendees does not include user' do
          before {
            @party.attendees.clear
            @party.attendees.should_not_receive(:delete)
            xhr :put, :unrsvp, id: @party.id, user_id: @current_user.id
          }

          it 'returns http 200' do
            response.response_code.should == 200
          end
        end
      end
    end
  end

  describe "invite" do
    before(:each) do
      @party.update_attribute(:organizer, @current_user)
      Party.should_receive(:find).and_return(@party)
      post :invite, :party => {user_ids:[1],emails:['test2@test.com'],inviter_id:@current_user.id,party_id:@party.id}, :format => :json
    end
    it "responds with status 201" do
      expect(response.status).to eq(201)
    end
    it "responds with json" do
      expect(JSON.parse(response.body)).to have_key('party')
    end
  end
end
