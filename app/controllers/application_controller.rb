class ApplicationController < AuthApp

  def json_response(data, status)
    content_type :json
    status status
    data.to_json
  end

  def authenticate!
    @current_user = User.find_by(id: decoded_token['user_id'])
    if current_user&.is_two_factor_enabled
      halt json_response({ error: 'Unauthorized' }, 401) unless decoded_token['otp_verified']
    else
      halt json_response({ error: 'Unauthorized' }, 401) unless current_user
    end
    return unless current_user && current_user.email_confirmed_at.nil?

    halt json_response({ error: 'Email confirmation is pending' }, 401)
  end

  def authenticate_with_password!
    @current_user = User.find_by(id: decoded_token['user_id'])
    halt json_response({ error: 'Unauthorized' }, 401) unless current_user
  end

  attr_reader :current_user

  def decoded_token
    return {} if is_token_revoked?

    @decoded_token ||= JwtService.decode(auth_token).to_h
  end

  def is_token_revoked?
    @_is_token_revoked ||= RevokedJwtToken.exists?(token: auth_token)
  end

  def auth_token
    request.env['HTTP_AUTHORIZATION']&.split(' ')&.last
  end

  def body_params
    @body_params ||= request_body
  end

  def request_body
    request.body.rewind
    decoded_body = Rack::Utils.parse_nested_query(request.body.read)['params']
    return JSON.parse(decoded_body)&.with_indifferent_access if decoded_body

    {}
  end
end
