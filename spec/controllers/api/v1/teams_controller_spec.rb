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
    context "date passed in" do
      before {
        Team.all.map(&:destroy)
        @t1 = Fabricate(:team, updated_at: (DateTime.now - 5.days))
        @t2 = Fabricate(:team, updated_at: (DateTime.now - 1.days))
        get :index, format: :json, date: (DateTime.now - 3.days).to_i.to_s
      }

      it "only returns t2" do
        response.body.should eq("{\"teams\":[{\"id\":3,\"created_at\":#{@t2.created_at.to_i},\"updated_at\":#{@t2.updated_at.to_i},\"name\":\"test_team\",\"information\":null,\"sport_id\":3,\"college\":false,\"website\":null,\"image_url\":\"/assets/placeholder.png\",\"address\":{\"id\":4,\"created_at\":#{@t2.address.created_at.to_i},\"updated_at\":#{@t2.address.updated_at.to_i},\"street1\":null,\"street2\":null,\"city\":null,\"state\":null,\"zip\":null,\"addressable_id\":3,\"addressable_type\":\"Team\",\"latitude\":null,\"longitude\":null},\"admin_ids\":[],\"fan_ids\":[],\"venue_fan_ids\":[],\"host_ids\":[],\"endorsement_request_ids\":[]}]}")
      end
      it 'returns http 200' do
        response.response_code.should == 200
      end
    end

    context 'no date passed in' do
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
    context "user not host" do
      it "adds user to team hosts" do
        expect {
          put :add_host, id: @team.id, user_id: @current_user.id, format: :json
        }.to change(@team.hosts, :count).by(1)
      end
    end
    context "user already host" do
      before {
        @team.hosts = [@current_user]
      }
      it "does not add user" do
        expect {
          put :add_host, id: @team.id, user_id: @current_user.id, format: :json
        }.to change(@team.hosts, :count).by(0)
      end
    end
  end

  describe "PUT remove_host" do
    context "user is host" do
      before {
        @team.hosts = [@current_user]
      }
      it "removes user from team hosts" do
        expect {
          put :remove_host, id: @team.id, user_id: @current_user.id, format: :json
        }.to change(@team.hosts, :count).by(-1)
      end
    end
    context "user not host" do
      it "does not remove user" do
        expect {
          put :remove_host, id: @team.id, user_id: @current_user.id, format: :json
        }.to change(@team.hosts, :count).by(0)
      end
    end
  end

  describe "PUT subscribe_user" do
    context "user not fan" do
      it "adds user to team fans" do
        expect {
          put :subscribe_user, id: @team.id, user_id: @current_user.id, format: :json
        }.to change(@team.fans, :count).by(1)
      end
    end
    context "user already fan" do
      before {
        @team.fans = [@current_user]
      }
      it "does not add user" do
        expect {
          put :subscribe_user, id: @team.id, user_id: @current_user.id, format: :json
        }.to change(@team.fans, :count).by(0)
      end
    end
  end

  describe "PUT unsubscribe_user" do
    context "user is fan" do
      before {
        @team.fans = [@current_user]
      }
      it "removes user from team fans" do
        expect {
          put :unsubscribe_user, id: @team.id, user_id: @current_user.id, format: :json
        }.to change(@team.fans, :count).by(-1)
      end
    end
    context "user not fan" do
      it "does not remove user" do
        expect {
          put :unsubscribe_user, id: @team.id, user_id: @current_user.id, format: :json
        }.to change(@team.fans, :count).by(0)
      end
    end
  end
end
