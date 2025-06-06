require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/dashboard/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /analytics" do
    it "returns http success" do
      get "/dashboard/analytics"
      expect(response).to have_http_status(:success)
    end
  end
end
