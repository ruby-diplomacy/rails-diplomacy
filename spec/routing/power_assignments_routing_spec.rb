require "spec_helper"

describe PowerAssignmentsController do
  describe "routing" do

    it "routes to #index" do
      get("/power_assignments").should route_to("power_assignments#index")
    end

    it "routes to #new" do
      get("/power_assignments/new").should route_to("power_assignments#new")
    end

    it "routes to #show" do
      get("/power_assignments/1").should route_to("power_assignments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/power_assignments/1/edit").should route_to("power_assignments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/power_assignments").should route_to("power_assignments#create")
    end

    it "routes to #update" do
      put("/power_assignments/1").should route_to("power_assignments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/power_assignments/1").should route_to("power_assignments#destroy", :id => "1")
    end

  end
end
