module Users
  class PasswordsController < ApplicationController

    before '/passwords' do
      authenticate!
    end

    patch '/passwords' do
      return json_response({ error: error_message }, 422) unless valid_update?

      if current_user.update(password: body_params[:new_password], password_confirmation: body_params[:new_password])
        json_response({ message: 'Password successfully updated' }, 200)
      else
        json_response({ error: current_user.errors.full_messages.join(', ') }, 422)
      end
    end

    private

    def valid_update?
      valid_otp? && valid_current_password?
    end

    def valid_otp?
      @valid_otp ||= OtpService.new(current_user).verify(body_params[:otp])
    end

    def valid_current_password?
      @valid_current_password ||= current_user.authenticate(body_params[:current_password])
    end

    def error_message
      return 'Invalid OTP' unless valid_otp?
      return 'Current password is invalid' unless valid_current_password?
    end
  end
end
