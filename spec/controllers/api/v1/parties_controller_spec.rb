require 'spec_helper'

describe Api::V1::PartiesController do
  let(:party) { Fabricate(:party) }
  let(:user) { Fabricate(:user) }
  before(:each) do
    Address.any_instance.stub(:geocode).and_return([1,1])
    party
    user
    user.confirm!
  end

  describe "build_scheduled_time" do
    it "should build the correct Time" do
      date = Date.new(2014, 10, 1)
      time = '10:00 pm'
      result = DateTime.new(2014, 10, 1, 22, 0, 0)
      subject.send(:build_scheduled_time, date, time).should == result
    end
  end

  describe "search_parties(search, address, radius)" do
    before(:each) do
      Venue.all.map(&:destroy)
      Party.all.map(&:destroy)
      @e1 = Venue.create(name: 'Bar 1', address: Fabricate(:address))
      @e2 = Venue.create(name: 'Bar 2', address: Fabricate(:address))
      @t = Team.create(name: 'Team 1')
      @p1 = Party.create(venue: @e1, name: 'Party 1', team: @t, scheduled_for: DateTime.now + 1.day, private: false)
      @p2 = Party.create(venue: @e2, name: 'Party 2', team: @t, scheduled_for: DateTime.now + 8.days, private: false)
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
      @p2.update_attribute(:private, true)
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

  describe 'GET index' do
    context 'index' do
      before do
        get :index
      end

      it "should not call search_parties" do
        subject.should_not_receive(:search_parties)
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'GET show' do
    context 'show' do
      before do
        get :show, id: party.id
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'POST create' do
    context 'user not authenticated' do
      before {
        user.ensure_authentication_token!
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :party => party.attributes.except('id')
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'party failed to save' do
      before {
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        e = Party.new
        Party.should_receive(:new).and_return(e)
        e.should_receive(:save).and_return(false)
        @party = Fabricate.attributes_for(:party)
        @party[:scheduled_date] = Date.new(2014, 01, 01)
        @party[:scheduled_time] = '10:00 pm'
        xhr :post, :create, :party => @party
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        @party = Fabricate.attributes_for(:party)
        @party[:scheduled_date] = Date.new(2014, 01, 01)
        @party[:scheduled_time] = '10:00 pm'
        xhr :post, :create, :party => @party
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end

    describe 'PUT update' do
      context 'current user not admin' do
        before {
          party = Fabricate(:party)
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :put, :update, id: party.id, party: {name: 'another_name'}
        }

        it 'returns http 403' do
          response.response_code.should == 403
        end
      end
      context 'current user is manager of another party' do
        before {
          party = Fabricate(:party)
          user.add_role(:party_manager)
          user.add_role(:manager, Fabricate(:party))
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :put, :update, id: party.id, party: {name: 'another_name'}
        }

        it 'returns http 403' do
          response.response_code.should == 403
        end
      end
      context 'current user not admin but is manager of the watch party' do
        before {
          party = Fabricate(:party)
          user.add_role(:manager, party)
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          @party = Fabricate.attributes_for(:party)
          @party[:scheduled_date] = Date.new(2014, 01, 01)
          @party[:scheduled_time] = '10:00 pm'
          @party[:name] = 'another_name'
          xhr :post, :create, :party => @party
          xhr :put, :update, id: party.id, party: @party
        }

        it 'returns http 200' do
          response.response_code.should == 200
        end
      end
      context 'user not authenticated' do
        before {
          user.ensure_authentication_token!
          request.headers['auth-token'] = 'fake_authentication_token'
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :post, :update, id: party.id, party: {name: 'another_name'}
        }

        it 'returns http 401' do
          response.response_code.should == 401
        end
      end
      context 'party failed to save' do
        before {
          party = Fabricate(:party)
          user.add_role :admin
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          Party.should_receive(:find).with(party.id.to_s).and_return(party)
          party.should_receive(:update!).and_return(false)
          @party = Fabricate.attributes_for(:party)
          @party[:scheduled_date] = Date.new(2014, 01, 01)
          @party[:scheduled_time] = '10:00 pm'
          @party[:name] = 'another_name'
          xhr :post, :create, :party => @party
          xhr :put, :update, id: party.id, party: @party
        }

        it 'returns http 422' do
          response.response_code.should == 422
        end
      end
      context 'everything is good' do
        before {
          party = Fabricate(:party)
          user.add_role :admin
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          @party = Fabricate.attributes_for(:party)
          @party[:scheduled_date] = Date.new(2014, 01, 01)
          @party[:scheduled_time] = '10:00 pm'
          @party[:name] = 'another_name'
          xhr :post, :create, :party => @party
          xhr :put, :update, id: party.id, party: @party
        }

        it 'returns http 200' do
          response.response_code.should == 200
        end
      end
    end
    describe 'DELETE destroy' do
      context 'current user not admin' do
        before {
          party = Fabricate(:party)
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :delete, :destroy, id: party.id
        }

        it 'returns http 403' do
          response.response_code.should == 403
        end
      end
      context 'current user is manager of another party' do
        before {
          party = Fabricate(:party)
          user.add_role(:party_manager)
          user.add_role(:manager, Fabricate(:party))
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :delete, :destroy, id: party.id
        }

        it 'returns http 403' do
          response.response_code.should == 403
        end
      end
      context 'current user not admin but is the manager of the party' do
        before {
          party = Fabricate(:party)
          user.add_role(:manager, party)
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :delete, :destroy, id: party.id
        }

        it 'returns http 200' do
          response.response_code.should == 200
        end
      end
      context 'user not authenticated' do
        before {
          user.ensure_authentication_token!
          request.headers['auth-token'] = 'fake_authentication_token'
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :post, :destroy, id: party.id
        }

        it 'returns http 401' do
          response.response_code.should == 401
        end
      end
      context 'party failed to save' do
        before {
          party = Fabricate(:party)
          user.add_role :admin
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          Party.should_receive(:find).with(party.id.to_s).and_return(party)
          party.should_receive(:destroy).and_return(false)
          xhr :delete, :destroy, id: party.id
        }

        it 'returns http 422' do
          response.response_code.should == 422
        end
      end
      context 'everything is good' do
        before {
          party = Fabricate(:party)
          user.add_role :admin
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :delete, :destroy, id: party.id
        }

        it 'returns http 200' do
          response.response_code.should == 200
        end
      end
    end
  end
end
