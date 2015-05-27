require "spec_helper"

describe SportsController do
  describe "routing" do

    it "routes to #index" do
      get("/sports").should route_to("sports#index")
    end

    it "routes to #new" do
      get("/sports/new").should route_to("sports#new")
    end

    it "routes to #show" do
      get("/sports/1").should route_to("sports#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sports/1/edit").should route_to("sports#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sports").should route_to("sports#create")
    end

    it "routes to #update" do
      put("/sports/1").should route_to("sports#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sports/1").should route_to("sports#destroy", :id => "1")
    end

  end
end
