require "rails_helper"

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /api/v1/users/login" do
    let(:user) { create(:user, password: "password123") }

    it "returns Authorization header and user+token in body" do
      post "/api/v1/users/login", params: { user: { email: user.email, password: "password123" } }, as: :json

      expect(response).to have_http_status(:ok)
      auth_header = response.headers["Authorization"]
      expect(auth_header).to be_present
      expect(auth_header).to match(/^Bearer /)

      json = JSON.parse(response.body)
      expect(json["data"]).to be_present
      expect(json["data"]["user"]["email"]).to eq(user.email)
      expect(json["data"]["token"]).to be_present
      expect(json["data"]["token_type"]).to eq("Bearer")
      expect(json["data"]["expires_at"]).to be_present
    end
  end
end
