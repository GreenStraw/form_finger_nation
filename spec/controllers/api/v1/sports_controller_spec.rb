require 'spec_helper'

describe Api::V1::SportsController do
  let(:sport) { Fabricate(:sport) }
  let(:user) { Fabricate(:user) }
  before do
    @sport = Fabricate.attributes_for(:sport)
    sport
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
        get :show, id: sport.id
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
        xhr :post, :create, :sport => @sport
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'user not authenticated' do
      before {
        user.ensure_authentication_token!
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :sport => @sport
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'sport failed to save' do
      before {
        user.admin = true
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        sp = Sport.new
        Sport.should_receive(:new).with(@sport).and_return(sp)
        sp.should_receive(:save).and_return(false)
        xhr :post, :create, :sport => @sport
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        user.admin = true
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :sport => @sport
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'PUT update' do
    context 'current user not admin' do
      before {
        sport = Fabricate(:sport)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: sport.id, sport: {name: 'another_name'}
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'user not authenticated' do
      before {
        user.ensure_authentication_token!
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :update, id: sport.id, sport: {name: 'another_name'}
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'sport failed to save' do
      before {
        sport = Fabricate(:sport)
        user.admin = true
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        Sport.should_receive(:find).with(sport.id.to_s).and_return(sport)
        sport.should_receive(:update!).and_return(false)
        xhr :put, :update, id: sport.id, sport: {name: 'another_name'}
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        sport = Fabricate(:sport)
        user.admin = true
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: sport.id, sport: {name: 'another_name'}
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'DELETE destroy' do
    context 'current user not admin' do
      before {
        sport = Fabricate(:sport)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: sport.id
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'user not authenticated' do
      before {
        user.ensure_authentication_token!
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :destroy, id: sport.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'sport failed to save' do
      before {
        sport = Fabricate(:sport)
        user.admin = true
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        Sport.should_receive(:find).with(sport.id.to_s).and_return(sport)
        sport.should_receive(:destroy).and_return(false)
        xhr :delete, :destroy, id: sport.id
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        sport = Fabricate(:sport)
        user.admin = true
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: sport.id
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end
end
