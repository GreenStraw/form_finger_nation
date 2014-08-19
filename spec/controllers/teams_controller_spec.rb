require 'spec_helper'

describe TeamsController do

  before(:each) do
    create_new_tenant
    login(:admin)
    @team = Fabricate(:team)
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
      get :new, {}
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
          post :create, {:team => valid_attributes}
        }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        post :create, {:team => valid_attributes}
        assigns(:team).should be_a(Team)
        assigns(:team).should be_persisted
      end

      it "redirects to the created team" do
        post :create, {:team => valid_attributes}
        response.should redirect_to(Team.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved team as @team" do
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        post :create, {:team => { "name" => "" }}
        assigns(:team).should be_a_new(Team)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        post :create, {:team => { "name" => "" }}
        response.should render_template("new")
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

    describe "with invalid params" do
      it "assigns the team as @team" do
        team = Team.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        put :update, {:id => @team.to_param, :team => { "name" => "" }}
        assigns(:team).should eq(@team)
      end

      it "re-renders the 'edit' template" do
        team = Team.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        put :update, {:id => @team.to_param, :team => { "name" => "" }}
        response.should render_template("edit")
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

end
