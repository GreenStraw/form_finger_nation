require "spec_helper"

describe VouchersController do
  describe "routing" do

    it "routes to #index" do
      get("/vouchers").should route_to("vouchers#index")
    end

    it "routes to #new" do
      get("/vouchers/new").should route_to("vouchers#new")
    end

    it "routes to #show" do
      get("/vouchers/1").should route_to("vouchers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/vouchers/1/edit").should route_to("vouchers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/vouchers").should route_to("vouchers#create")
    end

    it "routes to #update" do
      put("/vouchers/1").should route_to("vouchers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/vouchers/1").should route_to("vouchers#destroy", :id => "1")
    end

  end
end
