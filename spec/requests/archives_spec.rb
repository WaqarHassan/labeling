require 'rails_helper'

RSpec.describe "Archives", type: :request do
  describe "GET /archives" do
    it "works! (now write some real specs)" do
      get archives_path
      expect(response).to have_http_status(200)
    end
  end
end
