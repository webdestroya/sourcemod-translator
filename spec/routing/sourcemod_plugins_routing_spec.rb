require "spec_helper"

describe SourcemodPluginsController, pending: true do
  describe "routing" do

    it "routes to #index" do
      get("/sourcemod_plugins").should route_to("sourcemod_plugins#index")
    end

    it "routes to #new" do
      get("/sourcemod_plugins/new").should route_to("sourcemod_plugins#new")
    end

    it "routes to #show" do
      get("/sourcemod_plugins/1").should route_to("sourcemod_plugins#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sourcemod_plugins/1/edit").should route_to("sourcemod_plugins#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sourcemod_plugins").should route_to("sourcemod_plugins#create")
    end

    it "routes to #update" do
      put("/sourcemod_plugins/1").should route_to("sourcemod_plugins#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sourcemod_plugins/1").should route_to("sourcemod_plugins#destroy", :id => "1")
    end

  end
end
