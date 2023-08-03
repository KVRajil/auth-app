module Users
  class SessionsController < ApplicationController

    before '/logout' do
      authenticate_with_password!
    end

    # POST, 'users/login/', 'Login user'
    post '/login' do
      user = User.find_by(email: body_params[:email])

      if user&.authenticate(body_params[:password])
        token = JwtService.encode({ user_id: user.id }, 90.seconds)
        OtpService.new(user).generate_and_email
        json_response({ token: token }, 200)
      else
        json_response({ error: 'Invalid email or password' }, 401)
      end
    end

    # DELETE, 'users/logout/', 'Logout user'
    delete '/logout' do
      if RevokedJwtToken.revoke(auth_token)
        json_response({ message: 'Successfully logged out.' }, 200)
      else
        json_response({ error: 'Logout failed' }, 422)
      end
    end
  end
end
