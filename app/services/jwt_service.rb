class JwtService
  SECRET_KEY = ENV['JWT_SECRET_KEY']

  def self.encode(payload, _expiry = 1.minute)
    payload[:exp] = _expiry.from_now.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(jwt_token)
    JWT.decode(jwt_token, SECRET_KEY, true, algorithm: 'HS256').first
  rescue JWT::DecodeError
    nil
  end
end
