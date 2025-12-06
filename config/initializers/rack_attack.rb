module Rack
  class Attack
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    throttle("requests by ip", limit: 300, period: 5.minutes, &:ip)

    throttle("logins per ip", limit: 5, period: 20.seconds) do |req|
      req.ip if req.path == "/api/v1/auth/login" && req.post?
    end

    throttle("logins per email", limit: 5, period: 20.seconds) do |req|
      req.params["email"].to_s.downcase.presence if req.path == "/api/v1/auth/login" && req.post?
    end

    throttle("signups per ip", limit: 5, period: 1.hour) do |req|
      req.ip if req.path == "/api/v1/auth/signup" && req.post?
    end

    self.throttled_responder = lambda do |_env|
      [
        429,
        { "Content-Type" => "application/json" },
        [{ error: "Too many requests. Please try again later." }.to_json],
      ]
    end
  end
end
