require "rails_helper"

RSpec.describe EcrsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/ecrs").to route_to("ecrs#index")
    end

    it "routes to #new" do
      expect(:get => "/ecrs/new").to route_to("ecrs#new")
    end

    it "routes to #show" do
      expect(:get => "/ecrs/1").to route_to("ecrs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/ecrs/1/edit").to route_to("ecrs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/ecrs").to route_to("ecrs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/ecrs/1").to route_to("ecrs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/ecrs/1").to route_to("ecrs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/ecrs/1").to route_to("ecrs#destroy", :id => "1")
    end

  end
end
