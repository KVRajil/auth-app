module Users
  class RegistrationsController < ApplicationController

    # POST /users/signup/
    post '/signup' do
      user = User.new(user_params)
      if user.save
        send_email_confirmation(user)
        json_response({ message: 'User successfully created' }, 200)
      else
        json_response({ error: user.errors.full_messages.join(', ') }, 422)
      end
    end

    private

    def user_params
      {
        email: body_params['email'],
        password: body_params['password'],
        password_confirmation: body_params['password_confirmation']
      }
    end

    def send_email_confirmation(user)
      UserMailer.new.confirmation_email(user)
    end
  end
end
