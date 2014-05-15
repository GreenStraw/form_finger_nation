require 'spec_helper'

describe Api::V1::PartiesController do
  let(:party) { Fabricate(:party) }
  let(:user) { Fabricate(:user) }
  before do
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

  describe 'GET index' do
    context 'index' do
      before do
        get :index
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
    # context 'current user not admin' do
    #   before {
    #     user.ensure_authentication_token!
    #     request.headers['auth-token'] = user.authentication_token
    #     request.headers['auth-email'] = user.email
    #     subject.stub(:current_user).and_return(user)
    #     xhr :post, :create, :party => party.attributes.except('id')
    #   }

    #   it 'returns http 403' do
    #     response.response_code.should == 403
    #   end
    # end
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
