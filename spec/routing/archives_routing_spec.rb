require "rails_helper"

RSpec.describe ArchivesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/archives").to route_to("archives#index")
    end

    it "routes to #new" do
      expect(:get => "/archives/new").to route_to("archives#new")
    end

    it "routes to #show" do
      expect(:get => "/archives/1").to route_to("archives#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/archives/1/edit").to route_to("archives#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/archives").to route_to("archives#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/archives/1").to route_to("archives#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/archives/1").to route_to("archives#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/archives/1").to route_to("archives#destroy", :id => "1")
    end

  end
end
