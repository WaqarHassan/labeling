require 'rails_helper'

RSpec.describe "Ecrs", type: :request do
  describe "GET /ecrs" do
    it "works! (now write some real specs)" do
      get ecrs_path
      expect(response).to have_http_status(200)
    end
  end
end
