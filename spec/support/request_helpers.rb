require "devise/jwt/test_helpers"

module RequestHelpers
  def json
    JSON.parse(response.body)
  end

  def auth_headers(user)
    Devise::JWT::TestHelpers.auth_headers({ "Accept" => "application/json" }, user)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
