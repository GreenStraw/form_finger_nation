require 'spec_helper'

describe SportsController do

  before(:each) do
    create_new_tenant
    login(:admin)
    @sport = Fabricate(:sport)
  end

  let(:valid_attributes) { Fabricate.attributes_for(:sport) }

  describe "GET index" do
    it "assigns all sports as @sports" do
      get :index, {}
      assigns(:sports).should eq([@sport])
    end
  end

  describe "GET show" do
    it "assigns the requested sport as @sport" do
      get :show, {:id => @sport.to_param}
      assigns(:sport).should eq(@sport)
    end
  end

  describe "GET new" do
    it "assigns a new sport as @sport" do
      get :new, {}
      assigns(:sport).should be_a_new(Sport)
    end
  end

  describe "GET edit" do
    it "assigns the requested sport as @sport" do
      get :edit, {:id => @sport.to_param}
      assigns(:sport).should eq(@sport)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Sport" do
        expect {
          post :create, {:sport => valid_attributes}
        }.to change(Sport, :count).by(1)
      end

      it "assigns a newly created sport as @sport" do
        post :create, {:sport => valid_attributes}
        assigns(:sport).should be_a(Sport)
        assigns(:sport).should be_persisted
      end

      it "redirects to the created sport" do
        post :create, {:sport => valid_attributes}
        response.should redirect_to(Sport.last)
      end
    end
    describe "with invalid params" do
      it "assigns a newly created but unsaved sport as @sport" do
        # Trigger the behavior that occurs when invalid params are submitted
        Sport.any_instance.stub(:save).and_return(false)
        post :create, {:sport => { "name" => "invalid value" }}
        assigns(:sport).should be_a_new(Sport)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Sport.any_instance.stub(:save).and_return(false)
        post :create, {:sport => { "name" => "invalid value" }}
        response.should redirect_to(new_sport_path)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested sport" do
        # Assuming there are no other sports in the database, this
        # specifies that the Sport created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Sport.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => @sport.to_param, :sport => { "name" => "MyString" }}
      end

      it "assigns the requested sport as @sport" do
        put :update, {:id => @sport.to_param, :sport => valid_attributes}
        assigns(:sport).should eq(@sport)
      end

      it "redirects to the sport" do
        put :update, {:id => @sport.to_param, :sport => valid_attributes}
        response.should redirect_to(@sport)
      end
    end
    describe "with invalid params" do
      it "assigns the sport as @sport" do
        # Trigger the behavior that occurs when invalid params are submitted
        Sport.any_instance.stub(:save).and_return(false)
        put :update, {:id => @sport.to_param, :sport => { "name" => "invalid value" }}
        assigns(:sport).should eq(@sport)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Sport.any_instance.stub(:save).and_return(false)
        put :update, {:id => @sport.to_param, :sport => { "name" => "invalid value" }}
        response.should redirect_to(edit_sport_path(@sport))
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested sport" do
      expect {
        delete :destroy, {:id => @sport.to_param}
      }.to change(Sport, :count).by(-1)
    end

    it "redirects to the sports list" do
      delete :destroy, {:id => @sport.to_param}
      response.should redirect_to(sports_url)
    end
  end

end
