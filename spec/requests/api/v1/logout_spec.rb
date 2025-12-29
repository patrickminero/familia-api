require "rails_helper"

RSpec.describe "Api::V1::Sessions logout", type: :request do
  let(:user) { create(:user, password: "password123") }

  it "revokes the token and returns success message" do
    headers = auth_headers(user)

    expect do
      delete "/api/v1/users/logout", headers: headers
    end.to change(JwtDenylist, :count).by(1)

    expect(response).to have_http_status(:ok)
    json = response.parsed_body
    expect(json["message"]).to eq("Logged out successfully.")
  end
end
