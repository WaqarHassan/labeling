require 'rails_helper'

RSpec.describe "IaLists", type: :request do
  describe "GET /ia_lists" do
    it "works! (now write some real specs)" do
      get ia_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
