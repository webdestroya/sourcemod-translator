require "spec_helper"

describe FormatInfosController, pending: true do
  describe "routing" do

    it "routes to #index" do
      get("/format_infos").should route_to("format_infos#index")
    end

    it "routes to #new" do
      get("/format_infos/new").should route_to("format_infos#new")
    end

    it "routes to #show" do
      get("/format_infos/1").should route_to("format_infos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/format_infos/1/edit").should route_to("format_infos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/format_infos").should route_to("format_infos#create")
    end

    it "routes to #update" do
      put("/format_infos/1").should route_to("format_infos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/format_infos/1").should route_to("format_infos#destroy", :id => "1")
    end

  end
end
