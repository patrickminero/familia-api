Devise.setup do |config|
  config.jwt do |jwt|
    jwt.secret = ENV.fetch("DEVISE_JWT_SECRET_KEY") { Rails.application.credentials.devise_jwt_secret_key }
    # Dispatch on sessions create and registrations create (API paths)
    jwt.dispatch_requests = [
      ["POST", %r{^/api/v1/users/login$}],
      ["POST", %r{^/api/v1/users$}],
    ]
    # Revoke on sign out path
    jwt.revocation_requests = [
      ["DELETE", %r{^/api/v1/users/logout$}],
    ]
    jwt.expiration_time = 30.days.to_i
  end
end
