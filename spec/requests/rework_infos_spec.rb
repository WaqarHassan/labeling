require 'rails_helper'

RSpec.describe "ReworkInfos", type: :request do
  describe "GET /rework_infos" do
    it "works! (now write some real specs)" do
      get rework_infos_path
      expect(response).to have_http_status(200)
    end
  end
end
