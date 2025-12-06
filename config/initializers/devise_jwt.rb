Devise.setup do |config|
  config.jwt do |jwt|
    jwt.secret = ENV.fetch("DEVISE_JWT_SECRET_KEY") { Rails.application.credentials.devise_jwt_secret_key }
    jwt.dispatch_requests = [
      ["POST", %r{^/api/v1/auth/login$}],
    ]
    jwt.revocation_requests = [
      ["DELETE", %r{^/api/v1/auth/logout$}],
    ]
    jwt.expiration_time = 30.days.to_i
  end
end
