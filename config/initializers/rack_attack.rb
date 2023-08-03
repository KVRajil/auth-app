# This cache store can be moved to Redis
Rack::Attack.cache.store = ActiveSupport::Cache::FileStore.new('tmp/cache')

# Limit 100 requests per minute for each IP address
Rack::Attack.throttle('all_requests/ip', limit: 100, period: 1.minute) do |req|
  req.ip
end

# Limit login requests to 5 per minute for each IP address
Rack::Attack.throttle('login_request/ip', limit: 5, period: 1.minute) do |req|
  if req.path == 'users/login' && req.post?
    req.ip
  end
end

# Limit generate_otp requests to 2 per minute for each IP address
Rack::Attack.throttle('generate_otp_request/ip', limit: 2, period: 1.minute) do |req|
  if req.path == 'users/generate_otp' && req.post?
    req.ip
  end
end