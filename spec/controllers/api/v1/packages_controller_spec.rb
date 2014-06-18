require 'spec_helper'

describe Api::V1::PackagesController do
  render_views

  let(:package) { Fabricate(:package) }
  let(:user) { Fabricate(:user) }
  before(:each) do
    create_new_tenant
    package
    user
    request.headers['auth-token'] = user.authentication_token
    request.headers['auth-email'] = user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
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
        get :show, id: package.id
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'POST create' do
    context 'user not authenticated' do
      before {

        request.headers['auth-token'] = 'fake_authentication_token'
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :package => package.attributes.except('id')
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'package failed to save' do
      before {

        user.add_role(:manager, package.venue)
        subject.stub(:current_user).and_return(user)
        Package.should_receive(:new).and_return(package)
        package.should_receive(:save).and_return(false)
        xhr :post, :create, :package => package.attributes
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {

        user.add_role(:manager, package.venue)
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :package => {name: 'test', description: 'desc', price: 5.00, venue_id: package.venue.id}
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'PUT update' do
    context 'current user not admin or venue manager' do
      before {

        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: package.id, package: {name: 'another_name'}
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user is manager of another venue' do
      before {
        user.add_role(:manager, Fabricate(:venue))

        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: package.id, package: {name: 'another_name'}
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user not admin but is manager of the packages venue' do
      before {
        user.add_role(:manager, package.venue)

        subject.stub(:current_user).and_return(user)
        @package = Fabricate.attributes_for(:package)
        @package[:name] = 'another_name'
        xhr :post, :create, :package => @package
        xhr :put, :update, id: package.id, package: @package
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
    context 'user not authenticated' do
      before {

        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :update, id: package.id, package: {name: 'another_name'}
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'package failed to save' do
      before {
        user.add_role :admin

        subject.stub(:current_user).and_return(user)
        Package.should_receive(:find).with(package.id.to_s).and_return(package)
        package.should_receive(:update!).and_return(false)
        @package = Fabricate.attributes_for(:package)
        @package[:name] = 'another_name'
        xhr :post, :create, :package => @package
        xhr :put, :update, id: package.id, package: @package
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        user.add_role :admin

        subject.stub(:current_user).and_return(user)
        @package = Fabricate.attributes_for(:package)
        @package[:name] = 'another_name'
        xhr :post, :create, :package => @package
        xhr :put, :update, id: package.id, package: @package
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end
  describe 'DELETE destroy' do
    context 'current user not admin' do
      before {

        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: package.id
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user is manager of another venue' do
      before {
        user.add_role(:manager, Fabricate(:venue))

        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: package.id
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'current user not admin but is the manager of the venue' do
      before {
        user.add_role(:manager, package.venue)

        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: package.id
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
    context 'user not authenticated' do
      before {

        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :destroy, id: package.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'package failed to delete' do
      before {
        user.add_role :admin

        subject.stub(:current_user).and_return(user)
        Package.should_receive(:find).with(package.id.to_s).and_return(package)
        package.should_receive(:destroy).and_return(false)
        xhr :delete, :destroy, id: package.id
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        package = Fabricate(:package)
        user.add_role :admin

        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: package.id
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end
end
