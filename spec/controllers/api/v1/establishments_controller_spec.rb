require 'spec_helper'

describe Api::V1::VenuesController do
  let(:venue) { Fabricate(:venue) }
  let(:user) { Fabricate(:user) }
  before do
    @venue = Fabricate.attributes_for(:venue)
    venue
    user
    user.confirm!
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
        get :show, id: venue.id
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'POST create' do
    context 'current user not admin' do
      before {
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :venue => venue.attributes.except('id')
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user not admin but is venue_manager' do
      before {
        user.add_role(:venue_manager)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :venue => venue.attributes.except('id')
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
        xhr :post, :create, :venue => venue.attributes.except('id')
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'venue failed to save' do
      before {
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        e = Venue.new(user: user)
        Venue.should_receive(:new).and_return(e)
        e.should_receive(:save).and_return(false)
        xhr :post, :create, :venue => venue.attributes.except("id")
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :venue => venue.attributes
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'PUT update' do
    context 'current user not admin' do
      before {
        venue = Fabricate(:venue)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: venue.id, venue: {name: 'another_name'}
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user is manager of another venue' do
      before {
        venue = Fabricate(:venue)
        user.add_role(:venue_manager)
        user.add_role(:manager, Fabricate(:venue))
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: venue.id, venue: {name: 'another_name'}
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user not admin but is manager of the venue' do
      before {
        venue = Fabricate(:venue)
        user.add_role(:manager, venue)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: venue.id, venue: {name: 'another_name'}
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
        xhr :post, :update, id: venue.id, venue: {name: 'another_name'}
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'venue failed to save' do
      before {
        venue = Fabricate(:venue)
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        Venue.should_receive(:find).with(venue.id.to_s).and_return(venue)
        venue.should_receive(:update!).and_return(false)
        xhr :put, :update, id: venue.id, venue: {name: 'another_name'}
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        venue = Fabricate(:venue)
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: venue.id, venue: {name: 'another_name'}
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'DELETE destroy' do
    context 'current user not admin' do
      before {
        venue = Fabricate(:venue)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: venue.id
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user is manager of another venue' do
      before {
        venue = Fabricate(:venue)
        user.add_role(:venue_manager)
        user.add_role(:manager, Fabricate(:venue))
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: venue.id
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user not admin but is the manager of the venue' do
      before {
        venue = Fabricate(:venue)
        user.add_role(:manager, venue)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: venue.id
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
        xhr :post, :destroy, id: venue.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'venue failed to save' do
      before {
        venue = Fabricate(:venue)
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        Venue.should_receive(:find).with(venue.id.to_s).and_return(venue)
        venue.should_receive(:destroy).and_return(false)
        xhr :delete, :destroy, id: venue.id
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        venue = Fabricate(:venue)
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: venue.id
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end
end
