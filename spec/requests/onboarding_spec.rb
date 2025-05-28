require 'rails_helper'

RSpec.describe "Onboardings", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/onboarding/index"
      expect(response).to have_http_status(:success)
    end
  end
end
