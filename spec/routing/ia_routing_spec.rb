require "rails_helper"

RSpec.describe IaController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/ia").to route_to("ia#index")
    end

    it "routes to #new" do
      expect(:get => "/ia/new").to route_to("ia#new")
    end

    it "routes to #show" do
      expect(:get => "/ia/1").to route_to("ia#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/ia/1/edit").to route_to("ia#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/ia").to route_to("ia#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/ia/1").to route_to("ia#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/ia/1").to route_to("ia#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/ia/1").to route_to("ia#destroy", :id => "1")
    end

  end
end
