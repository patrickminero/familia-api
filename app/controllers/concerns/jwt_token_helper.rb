module JwtTokenHelper
  private

  def jwt_secret
    ENV.fetch("DEVISE_JWT_SECRET_KEY") do
      Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base
    end
  end

  def jwt_token_from_env_or_header
    token = request.env["warden-jwt_auth.token"] || response.headers["Authorization"]&.split&.last
    normalize_bearer(token)
  end

  def jwt_token_from_header
    normalize_bearer(request.headers["Authorization"]&.split&.last)
  end

  def jwt_exp_from_token(token)
    payload = decode_jwt_payload(token)
    return nil unless payload && payload["exp"]

    Time.at(payload["exp"]).utc.iso8601
  end

  def decode_jwt_payload(token)
    return nil unless token

    JWT.decode(token, jwt_secret).first
  rescue JWT::DecodeError
    nil
  end

  def revoke_jwt(token)
    payload = decode_jwt_payload(token)
    return false unless payload

    JwtDenylist.create!(jti: payload["jti"], exp: Time.at(payload["exp"])) # rubocop:disable Rails/TimeZone
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def normalize_bearer(token)
    return nil unless token

    token.to_s.start_with?("Bearer ") ? token.split.last : token
  end
end
