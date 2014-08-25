require 'spec_helper'

describe TeamsController do

  before(:each) do
    create_new_tenant
    login(:admin)
    @team = Fabricate(:team)
    @sport = Fabricate(:sport)
  end

  let(:valid_attributes) { Fabricate.attributes_for(:team) }

  describe "GET index" do
    it "assigns all teams as @teams" do
      get :index, {}
      assigns(:teams).should eq([@team])
    end
  end

  describe "GET show" do
    it "assigns the requested team as @team" do
      get :show, {:id => @team.to_param}
      assigns(:team).should eq(@team)
    end
  end

  describe "GET new" do
    it "assigns a new team as @team" do
      get :new, {sport_id: @sport.id}
      assigns(:team).should be_a_new(Team)
    end
  end

  describe "GET edit" do
    it "assigns the requested team as @team" do
      get :edit, {:id => @team.to_param}
      assigns(:team).should eq(@team)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Team" do
        expect {
          post :create, {:team => valid_attributes, sport_id: valid_attributes[:sport_id]}
        }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        post :create, {:team => valid_attributes, sport_id: valid_attributes[:sport_id]}
        assigns(:team).should be_a(Team)
        assigns(:team).should be_persisted
      end

      it "redirects to the created team" do
        post :create, {:team => valid_attributes, sport_id: valid_attributes[:sport_id]}
        response.should redirect_to(edit_sport_path(valid_attributes[:sport_id]))
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested team" do
        # Assuming there are no other teams in the database, this
        # specifies that the Team created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Team.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => @team.to_param, :team => { "name" => "MyString" }}
      end

      it "assigns the requested team as @team" do
        put :update, {:id => @team.to_param, :team => valid_attributes}
        assigns(:team).should eq(@team)
      end

      it "redirects to the team" do
        team = Team.create! valid_attributes
        put :update, {:id => @team.to_param, :team => valid_attributes}
        response.should redirect_to(@team)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested team" do
      expect {
        delete :destroy, {:id => @team.to_param}
      }.to change(Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      delete :destroy, {:id => @team.to_param}
      response.should redirect_to(teams_url)
    end
  end

  describe "PUT subscribe_user" do
    context "user not fan" do
      it "adds user to team fans" do
        expect {
          put :subscribe, id: @team.id, format: :js
        }.to change(@team.fans, :count).by(1)
      end
    end
    context "user already fan" do
      before {
        @team.fans = [@current_user]
      }
      it "does not add user" do
        expect {
          put :subscribe, id: @team.id, format: :js
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
          put :unsubscribe, id: @team.id, format: :js
        }.to change(@team.fans, :count).by(-1)
      end
    end
    context "user not fan" do
      it "does not remove user" do
        expect {
          put :unsubscribe, id: @team.id, format: :js
        }.to change(@team.fans, :count).by(0)
      end
    end
  end

  describe "PUT add_host" do
    context "user not host" do
      it "adds user to team hosts" do
        expect {
          put :add_host, id: @team.id, user_id: current_user.id, format: :js
        }.to change(@team.hosts, :count).by(1)
      end
    end
    context "user already host" do
      before {
        @team.hosts = [@current_user]
      }
      it "does not add user" do
        expect {
          put :add_host, id: @team.id, user_id: current_user.id, format: :js
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
          put :remove_host, id: @team.id, user_id: current_user.id, format: :js
        }.to change(@team.hosts, :count).by(-1)
      end
    end
    context "user not host" do
      it "does not remove user" do
        expect {
          put :remove_host, id: @team.id, user_id: current_user.id, format: :js
        }.to change(@team.hosts, :count).by(0)
      end
    end
  end

  describe "PUT add_admin" do
    context "user not admin" do
      it "give user team admin role" do
        expect {
          put :add_admin, id: @team.id, user_id: current_user.id, format: :js
        }.to change(@team.admins, :count).by(1)
      end
    end
    context "user already fan" do
      before {
        current_user.add_role(:team_admin, @team)
      }
      it "does not add user" do
        expect {
          put :add_admin, id: @team.id, user_id: current_user.id, format: :js
        }.to change(@team.admins, :count).by(0)
      end
    end
  end

  describe "PUT remove_admin" do
    context "user admin" do
      before {
        current_user.add_role(:team_admin, @team)
      }
      it "remove user team admin role" do
        expect {
          put :remove_admin, id: @team.id, user_id: current_user.id, format: :js
        }.to change(@team.admins, :count).by(-1)
      end
    end
    context "user not admin" do
      it "does not remove user role" do
        expect {
          put :remove_admin, id: @team.id, user_id: current_user.id, format: :js
        }.to change(@team.admins, :count).by(0)
      end
    end
  end

end
