require "rails_helper"

RSpec.describe "Api::V1::Households", type: :request do
  let(:user) { create(:user, :with_profile) }
  let(:household) { create(:household, user: user) }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/households" do
    it "returns all user's households" do
      household
      get "/api/v1/households", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json["data"]).to be_an(Array)
      expect(json["data"].first["name"]).to eq(household.name)
    end

    it "returns 401 without authentication" do
      get "/api/v1/households"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/households/:id" do
    it "returns the household" do
      get "/api/v1/households/#{household.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json["data"]["id"]).to eq(household.id)
      expect(json["data"]["name"]).to eq(household.name)
    end

    it "returns 404 for household not belonging to user" do
      other_household = create(:household)
      get "/api/v1/households/#{other_household.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/households" do
    it "creates a new household" do
      household_params = { name: "Test Family" }

      expect do
        post "/api/v1/households", params: { household: household_params }, headers: headers
      end.to change(Household, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json["data"]["name"]).to eq("Test Family")
    end

    it "returns 422 with invalid params" do
      post "/api/v1/households", params: { household: { name: "" } }, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to be_present
    end
  end

  describe "PATCH /api/v1/households/:id" do
    it "updates the household" do
      patch "/api/v1/households/#{household.id}",
            params: { household: { name: "Updated Family" } },
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(json["data"]["name"]).to eq("Updated Family")
      expect(household.reload.name).to eq("Updated Family")
    end

    it "returns 404 for household not belonging to user" do
      other_household = create(:household)
      patch "/api/v1/households/#{other_household.id}",
            params: { household: { name: "Hacked" } },
            headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/households/:id" do
    it "deletes the household" do
      household

      expect do
        delete "/api/v1/households/#{household.id}", headers: headers
      end.to change(Household, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end

    it "returns 404 for household not belonging to user" do
      other_household = create(:household)
      delete "/api/v1/households/#{other_household.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
