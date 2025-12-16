module Jwt
  class TokenGenerator
    def self.call(user)
      payload = { user_id: user.id, exp: 30.days.from_now.to_i }
      JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base)
    end
  end
end
