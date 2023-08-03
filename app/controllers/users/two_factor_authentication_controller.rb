module Users
  class TwoFactorAuthenticationController < ApplicationController

    before '/generate_otp' do
      authenticate_with_password!
    end

    before '/verify_otp' do
      authenticate_with_password!
    end

    before '/toggle_2fa' do
      authenticate!
    end

    # api :POST, 'users/generate_otp/', 'Generate OTP'
    post '/generate_otp' do
      if OtpService.new(current_user).generate_and_email
        json_response({ message: 'OTP sent to the email address' }, 200)
      else
        json_response({ error: 'OTP creation failed' }, 422)
      end
    end

    # api :POST, 'users/verify_otp/', 'Verify OTP'
    post '/verify_otp' do
      if OtpService.new(current_user).verify(body_params[:otp])
        payload = { user_id: current_user.id, otp_verified: true }
        token   = JwtService.encode(payload, 5.minutes)
        json_response({ token: token }, 200)
      else
        json_response({ error: 'Invalid OTP' }, 401)
      end
    end

    # api :PATCH, 'users/toggle_2fa/', 'Toggle 2FA'
    patch '/toggle_2fa' do
      if valid_update?
        current_user.update!(is_two_factor_enabled: body_params[:enable_2fa])
        json_response({ message: toggle_message }, 200)
      else
        json_response({ error: error_message }, 422)
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

    def toggle_message
      if body_params[:enable_2fa] == true
        "2FA is enabled. Use #{current_user.otp_secret} to cofigure the 2FA application."
      else
        '2FA is disabled'
      end
    end
  end
end
