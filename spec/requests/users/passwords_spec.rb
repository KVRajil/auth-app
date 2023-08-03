require 'spec_helper'

RSpec.describe 'User::Confirmation', type: :request do
  let!(:user) do
    create(:user, email: 'test@gmail.com', password: 'Test@123', password_confirmation: 'Test@123',
                  email_confirmed_at: Time.now)
  end
  let(:json_response) { JSON.parse(last_response.body).with_indifferent_access }
  let!(:headers) { { ACCEPT: 'application/json', CONTENT_TYPE: 'application/json' } }

  describe 'PATCH #update' do
    context 'Valid scenarios' do
      it 'updates the password' do
        token = JwtService.encode({ user_id: user.id, otp_verified: true })
        otp   = OtpService.new(user).generate
        header 'Authorization', "Bearer #{token}"
        params = { current_password: 'Test@123', new_password: 'TestNew@123', otp: otp }
        patch('/users/passwords', params.to_json, headers)
        expect(last_response.status).to eq(200)
        expect(json_response['message']).to eq('Password successfully updated')
      end
    end

    context 'Invalid scenarios' do
      it 'returns unauthorized status when the jwt token is not provided' do
        otp = OtpService.new(user).generate
        params = { current_password: 'Test@123', new_password: 'TestNew@123', otp: otp }
        patch('/users/passwords', params.to_json, headers)
        expect(last_response.status).to eq(401)
      end

      it 'returns unauthorized status when the current password is wrong' do
        otp = OtpService.new(user).generate
        params = { current_password: 'Test@123Wrong', new_password: 'TestNew@123', otp: otp }
        patch('/users/passwords', params.to_json, headers)
        expect(last_response.status).to eq(401)
      end

      it 'returns error status when the OTP is wrong' do
        token = JwtService.encode({ user_id: user.id, otp_verified: true })
        header 'Authorization', "Bearer #{token}"
        params = { current_password: 'Test@123', new_password: 'TestNew@123', otp: 'wrong' }
        patch('/users/passwords', params.to_json, headers)
        expect(last_response.status).to eq(422)
      end
    end
  end
end
