class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle("requests by ip", limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  throttle("logins per ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/api/v1/auth/login" && req.post?
      req.ip
    end
  end

  throttle("logins per email", limit: 5, period: 20.seconds) do |req|
    if req.path == "/api/v1/auth/login" && req.post?
      req.params["email"].to_s.downcase.presence
    end
  end

  throttle("signups per ip", limit: 5, period: 1.hour) do |req|
    if req.path == "/api/v1/auth/signup" && req.post?
      req.ip
    end
  end

  self.throttled_responder = lambda do |env|
    [
      429,
      {"Content-Type" => "application/json"},
      [{error: "Too many requests. Please try again later."}.to_json]
    ]
  end
end
