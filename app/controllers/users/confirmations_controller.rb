module Users
  class ConfirmationsController < ApplicationController

    # GET /users/confirmations/:token
    get '/confirmations/:token' do
      user = User.find_by(confirmation_token: params[:token])

      if user
        user.update!(email_confirmed_at: Time.now, confirmation_token: nil)
        json_response({ message: 'Email successfully confirmed' }, 200)
      else
        json_response({ error: 'Invalid confirmation link' }, 422)
      end
    end

    # POST /users/confirmations/
    post '/confirmations' do
      user = User.find_by(email: body_params[:email])

      return json_response({ error: 'Invalid email id or password' }, 401) unless user&.authenticate(body_params[:password])
      return json_response({ message: 'Email already confirmed' }, 200) if user.email_confirmed_at.present?

      user.update_confirmation_token
      UserMailer.new.confirmation_email(user)
      json_response({ message: 'Confirmation email sent.' }, 200)
    end
  end
end
