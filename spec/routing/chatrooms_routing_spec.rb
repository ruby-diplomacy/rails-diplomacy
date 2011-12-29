require "spec_helper"

describe ChatroomsController do
  describe "routing" do

    it "routes to #index" do
      get("/chatrooms").should route_to("chatrooms#index")
    end

    it "routes to #new" do
      get("/chatrooms/new").should route_to("chatrooms#new")
    end

    it "routes to #show" do
      get("/chatrooms/1").should route_to("chatrooms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/chatrooms/1/edit").should route_to("chatrooms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/chatrooms").should route_to("chatrooms#create")
    end

    it "routes to #update" do
      put("/chatrooms/1").should route_to("chatrooms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/chatrooms/1").should route_to("chatrooms#destroy", :id => "1")
    end

  end
end
