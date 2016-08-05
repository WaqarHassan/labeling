require "rails_helper"

RSpec.describe IaListsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/ia_lists").to route_to("ia_lists#index")
    end

    it "routes to #new" do
      expect(:get => "/ia_lists/new").to route_to("ia_lists#new")
    end

    it "routes to #show" do
      expect(:get => "/ia_lists/1").to route_to("ia_lists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/ia_lists/1/edit").to route_to("ia_lists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/ia_lists").to route_to("ia_lists#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/ia_lists/1").to route_to("ia_lists#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/ia_lists/1").to route_to("ia_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/ia_lists/1").to route_to("ia_lists#destroy", :id => "1")
    end

  end
end
