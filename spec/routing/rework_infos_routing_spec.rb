require "rails_helper"

RSpec.describe ReworkInfosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/rework_infos").to route_to("rework_infos#index")
    end

    it "routes to #new" do
      expect(:get => "/rework_infos/new").to route_to("rework_infos#new")
    end

    it "routes to #show" do
      expect(:get => "/rework_infos/1").to route_to("rework_infos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/rework_infos/1/edit").to route_to("rework_infos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/rework_infos").to route_to("rework_infos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/rework_infos/1").to route_to("rework_infos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/rework_infos/1").to route_to("rework_infos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/rework_infos/1").to route_to("rework_infos#destroy", :id => "1")
    end

  end
end
