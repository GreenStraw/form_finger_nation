require 'spec_helper'

describe Api::V1::PackagesController do
  render_views

  before(:each) do
    create_new_tenant
    login(:admin)
    @package = Fabricate(:package)
    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:valid_attributes) { Fabricate.attributes_for(:venue) }

  describe 'GET index' do
    context 'index' do
      before do
        get :index, format: :json
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'GET show' do
    context 'show' do
      before do
        get :show, id: @package.id, format: :json
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
        xhr :post, :create, :package => @package.attributes.except('id')
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    describe "with valid params" do
      before(:each) do
        post :create, :package => valid_attributes, format: :json
      end
      it "assigns a newly created package as @package" do
        assigns(:package).should be_a(Package)
      end
      it "creates a new Package" do
        assigns(:package).should be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
      it "responds with json" do
        expect(JSON.parse(response.body)).to have_key('package')
      end
    end

    describe "with invalid params" do
      before(:each) do
        post :create, :package => { "name" => "" }, :format => :json
      end
      it "assigns a newly created but unsaved activity as @package" do
        assigns(:package).should be_a_new(Package)
      end
      it "dos not persist the package" do
        assigns(:package).should_not be_persisted
      end
      it "responds with status 422" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT update' do
    context 'current user not admin or venue manager' do
      before {
        @current_user.roles.clear
      }

      it 'access denied' do
        expect{
            xhr :put, :update, id: @package.id, package: {name: 'another_name'}
          }.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'current user is manager of another venue' do
      before {
        @current_user.roles.clear
        @current_user.add_role(:manager, Fabricate(:venue))
      }

      it 'access denied' do
        expect{
            xhr :put, :update, id: @package.id, package: {name: 'another_name'}
          }.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'current user not admin but is manager of the packages venue' do
      before {
        @current_user.add_role(:manager, @package.venue)
        package = Fabricate.attributes_for(:package)
        package[:name] = 'another_name'
        xhr :put, :update, id: @package.id, package: package
      }

      it 'returns http 204' do
        response.response_code.should == 204
      end
    end
    context 'user not authenticated' do
      before {
        request.headers['auth-token'] = 'fake_authentication_token'
        xhr :post, :update, id: @package.id, package: {name: 'another_name'}
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    describe "with invalid params" do
      before(:each) do
        Package.should_receive(:find).and_return(@package)
        @package.should_receive(:valid?).and_return(false)
        @package.errors.add(:base, "some generic error")
        put :update, :id => @package.to_param, :package => { "user_id" => "" }, :format => :json
      end
      it "assigns the activity as @package" do
        assigns(:package).should eq(@package)
      end
      it "should return the error as json" do
        response.body.should eq("{\"errors\":{\"base\":[\"some generic error\"]}}")
      end
    end
    context 'everything is good' do
      before {
        @current_user.add_role :admin
        package = Fabricate.attributes_for(:package)
        package[:name] = 'another_name'
      }

      it 'returns http 200' do
        expect(response.response_code).to eq(200)
      end
    end
  end
  describe 'DELETE destroy' do
    context 'current user not admin' do
      before {
        @current_user.roles.clear
      }

      it 'access denied' do
        expect{
            xhr :delete, :destroy, id: @package.id
          }.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'current user is manager of another venue' do
      before {
        @current_user.roles.clear
        @current_user.add_role(:manager, Fabricate(:venue))
      }

      it 'access denied' do
        expect{
            xhr :delete, :destroy, id: @package.id
          }.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'current user not admin but is the manager of the venue' do
      before {
        @current_user.add_role(:manager, @package.venue)
        xhr :delete, :destroy, id: @package.id
      }

      it 'returns http 204' do
        response.response_code.should == 204
      end
    end
    context 'user not authenticated' do
      before {
        request.headers['auth-token'] = 'fake_authentication_token'
        xhr :post, :destroy, id: @package.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'everything is good' do
      before {
        xhr :delete, :destroy, id: @package.id
      }

      it 'returns http 204' do
        response.response_code.should == 204
      end
    end
  end
end
