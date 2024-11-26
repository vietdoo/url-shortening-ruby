class Rack::Attack
  throttle('req/ip', limit: 10, period: 1.minute) do |req|
    if req.path == '/encode' || req.path == '/decode'
      req.ip
    end
  end

  self.throttled_response = lambda do |env|
    [ 429,  
      { 'Content-Type' => 'application/json' },
      [{ status: 'error', message: 'Rate limit exceeded. Try again later.' }.to_json]  # body
    ]
  end
end