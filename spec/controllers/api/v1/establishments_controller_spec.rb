require 'spec_helper'

describe Api::V1::EstablishmentsController do
  let(:establishment) { Fabricate(:establishment) }
  let(:user) { Fabricate(:user) }
  before do
    @establishment = Fabricate.attributes_for(:establishment)
    establishment
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
        get :show, id: establishment.id
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
        xhr :post, :create, :establishment => establishment.attributes.except('id')
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user not admin but is establishment_manager' do
      before {
        user.add_role(:establishment_manager)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :establishment => establishment.attributes.except('id')
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
        xhr :post, :create, :establishment => establishment.attributes.except('id')
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'establishment failed to save' do
      before {
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        e = Establishment.new(user: user)
        Establishment.should_receive(:new).and_return(e)
        e.should_receive(:save).and_return(false)
        xhr :post, :create, :establishment => establishment.attributes.except("id")
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
        xhr :post, :create, :establishment => establishment.attributes
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'PUT update' do
    context 'current user not admin' do
      before {
        establishment = Fabricate(:establishment)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: establishment.id, establishment: {name: 'another_name'}
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user is manager of another establishment' do
      before {
        establishment = Fabricate(:establishment)
        user.add_role(:establishment_manager)
        user.add_role(:manager, Fabricate(:establishment))
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: establishment.id, establishment: {name: 'another_name'}
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user not admin but is manager of the establishment' do
      before {
        establishment = Fabricate(:establishment)
        user.add_role(:manager, establishment)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: establishment.id, establishment: {name: 'another_name'}
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
        xhr :post, :update, id: establishment.id, establishment: {name: 'another_name'}
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'establishment failed to save' do
      before {
        establishment = Fabricate(:establishment)
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        Establishment.should_receive(:find).with(establishment.id.to_s).and_return(establishment)
        establishment.should_receive(:update!).and_return(false)
        xhr :put, :update, id: establishment.id, establishment: {name: 'another_name'}
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        establishment = Fabricate(:establishment)
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: establishment.id, establishment: {name: 'another_name'}
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'DELETE destroy' do
    context 'current user not admin' do
      before {
        establishment = Fabricate(:establishment)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: establishment.id
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user is manager of another establishment' do
      before {
        establishment = Fabricate(:establishment)
        user.add_role(:establishment_manager)
        user.add_role(:manager, Fabricate(:establishment))
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: establishment.id
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user not admin but is the manager of the establishment' do
      before {
        establishment = Fabricate(:establishment)
        user.add_role(:manager, establishment)
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: establishment.id
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
        xhr :post, :destroy, id: establishment.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'establishment failed to save' do
      before {
        establishment = Fabricate(:establishment)
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        Establishment.should_receive(:find).with(establishment.id.to_s).and_return(establishment)
        establishment.should_receive(:destroy).and_return(false)
        xhr :delete, :destroy, id: establishment.id
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        establishment = Fabricate(:establishment)
        user.add_role :admin
        user.ensure_authentication_token!
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: establishment.id
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end
end
