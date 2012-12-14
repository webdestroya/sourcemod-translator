require "spec_helper"

describe TranslationsController do
  describe "routing" do

    it "routes to #index" do
      get("/translations").should route_to("translations#index")
    end

    it "routes to #new" do
      get("/translations/new").should route_to("translations#new")
    end

    it "routes to #show" do
      get("/translations/1").should route_to("translations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/translations/1/edit").should route_to("translations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/translations").should route_to("translations#create")
    end

    it "routes to #update" do
      put("/translations/1").should route_to("translations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/translations/1").should route_to("translations#destroy", :id => "1")
    end

  end
end
