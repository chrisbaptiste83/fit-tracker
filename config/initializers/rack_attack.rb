class Rack::Attack
  throttle("ai/user", limit: 20, period: 1.minute) do |req|
    req.session["user_id"] if req.path.start_with?("/ai") && req.post?
  end

  throttle("ai/ip", limit: 30, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/ai")
  end

  self.throttled_responder = lambda do |req|
    [429, { "Content-Type" => "application/json" }, [{ error: "Rate limit exceeded. Try again shortly." }.to_json]]
  end
end
