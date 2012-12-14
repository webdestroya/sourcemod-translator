require "spec_helper"

describe PhrasesController do
  describe "routing" do

    it "routes to #index" do
      get("/phrases").should route_to("phrases#index")
    end

    it "routes to #new" do
      get("/phrases/new").should route_to("phrases#new")
    end

    it "routes to #show" do
      get("/phrases/1").should route_to("phrases#show", :id => "1")
    end

    it "routes to #edit" do
      get("/phrases/1/edit").should route_to("phrases#edit", :id => "1")
    end

    it "routes to #create" do
      post("/phrases").should route_to("phrases#create")
    end

    it "routes to #update" do
      put("/phrases/1").should route_to("phrases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/phrases/1").should route_to("phrases#destroy", :id => "1")
    end

  end
end
