require 'spec_helper'

describe Api::V1::TeamsController do
  render_views

  before do
    create_new_tenant
    login(:admin)
    @team = Fabricate(:team)
    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:valid_attributes) { Fabricate.attributes_for(:team) }

  describe 'GET index' do
    context 'index' do
      before do
        get :index, format: :json
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
      it "assigns all parties as @teams" do
        assigns(:teams).should_not be_nil
      end
    end
  end

  describe 'GET show' do
    context 'show' do
      before do
        get :show, id: @team.id, format: :json
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        post :create, :team => valid_attributes, format: :json
      end
      it "assigns a newly created team as @team" do
        assigns(:team).should be_a(Team)
      end
      it "creates a new Team" do
        assigns(:team).should be_persisted
      end
      it "responds with status 201" do
        expect(response.status).to eq(201)
      end
      it "responds with json" do
        expect(JSON.parse(response.body)).to have_key('team')
      end
    end

    describe "with invalid params" do
      before(:each) do
        post :create, :team => { "name" => "" }, :format => :json
      end
      it "assigns a newly created but unsaved activity as @team" do
        assigns(:team).should be_a_new(Team)
      end
      it "dos not persist the team" do
        assigns(:team).should_not be_persisted
      end
      it "responds with status 422" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        Team.any_instance.should_receive(:update)
        put :update, :id => @team.to_param, :team => valid_attributes, :format => :json
      end
      it "assigns the requested activity as @team" do
        assigns(:team).should eq(@team)
      end
      it "responds with status 204" do
        expect(response.status).to eq(204)
      end
      it "responds with json" do
        # expect(JSON.parse(response.body)).to have_key('team')
        response.body.should == ''
      end
    end

    describe "with invalid params" do
      before(:each) do
        Team.should_receive(:find).and_return(@team)
        @team.should_receive(:valid?).and_return(false)
        @team.errors.add(:base, "some generic error")
        put :update, :id => @team.to_param, :team => { "name" => "" }, :format => :json
      end
      it "assigns the activity as @team" do
        assigns(:team).should eq(@team)
      end
      it "responds with status 422" do
        expect(response.status).to eq(422)
      end
      it "should return the error as json" do
        response.body.should eq("{\"errors\":{\"base\":[\"some generic error\"]}}")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested activity" do
      expect {
        delete :destroy, :id => @team.to_param, :format => :json
      }.to change(Team, :count).by(-1)
    end
  end

  describe "PUT add_host" do
    context 'user not authenticated' do
      before {
        request.headers['auth-token'] = 'fake_authentication_token'
        xhr :post, :add_host, id: @team.id, user_id: @current_user.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'user authenticated' do
      context 'current user does have team admin role for team' do
        before {
          @current_user.add_role(:team_admin, @team)
          xhr :post, :add_host, id: @team.id, user_id: @current_user.id
        }

        it 'returns http 200' do
          response.response_code.should == 200
        end
      end
      context 'team already includes user as a host' do
        it 'should not call <<' do
          @current_user.add_role(:team_admin, @team)
          @team.endorsed_hosts = [@current_user]
          @team.should_not_receive(:<<)
          xhr :post, :add_host, id: @team.id, user_id: @current_user.id
        end
      end
      context 'team does not include user as a host' do
        it 'should add user to endorsed_hosts' do
          @current_user.add_role(:team_admin, @team)
          @team.endorsed_hosts.should_not include(@current_user)
          xhr :post, :add_host, id: @team.id, user_id: @current_user.id
          assigns(:team).endorsed_hosts.should include(@current_user)
        end
      end
    end
  end

  describe "PUT remove_host" do
    context 'user not authenticated' do
      before {
        request.headers['auth-token'] = 'fake_authentication_token'
        xhr :post, :remove_host, id: @team.id, user_id: @current_user.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'user authenticated' do
      context 'current user does have team admin role for team' do
        before {
          @current_user.add_role(:team_admin, @team)
          xhr :post, :remove_host, id: @team.id, user_id: @current_user.id
        }

        it 'returns http 200' do
          response.response_code.should == 200
        end
      end
      context 'team already includes user as a host' do
        it 'should remove the user' do
          @current_user.add_role(:team_admin, @team)
          @team.endorsed_hosts = [@current_user]
          @team.endorsed_hosts.should include(@current_user)
          xhr :post, :remove_host, id: @team.id, user_id: @current_user.id
          assigns(:team).endorsed_hosts.should_not include(@current_user)
        end
      end
      context 'team does not include user as a host' do
        it 'should not call delete' do
          @current_user.add_role(:team_admin, @team)
          @team.endorsed_hosts.should_not_receive(:delete)
          xhr :post, :remove_host, id: @team.id, user_id: @current_user.id
        end
      end
    end
  end
end
