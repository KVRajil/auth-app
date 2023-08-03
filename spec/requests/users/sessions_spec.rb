require 'spec_helper'

RSpec.describe 'User::Session', type: :request do
  let!(:user) { create(:user, email: 'test@gmail.com', password: 'Test@123', password_confirmation: 'Test@123') }
  let(:json_response) { JSON.parse(last_response.body).with_indifferent_access }
  let!(:headers) do
    { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
  end
  describe 'users/login' do
    context 'Valid scenarios' do
      it 'should login and generate a jwt token' do
        params = { email: 'test@gmail.com', password: 'Test@123' }
        post('/users/login', params.to_json, headers)

        expect(last_response.status).to eq(200)
        expect(json_response['token']).to be_present
      end
    end

    context 'Invalid scenarios' do
      it 'should fail to login' do
        params = { email: 'test@gmail.com', password: 'wrong password' }
        post('/users/login', params.to_json, headers)

        expect(last_response.status).to eq(401)
        expect(json_response['error']).to eq('Invalid email or password')
      end
    end
  end

  describe 'users/logout' do
    context 'Valid scenarios' do
      it 'should logout and generate a revoked jwt token' do
        token = JwtService.encode({ user_id: user.id })
        header 'Authorization', "Bearer #{token}"
        delete('/users/logout', {}.to_json, headers)

        expect(last_response.status).to eq(200)
        expect(RevokedJwtToken.find_by(token: token)).to be_present
      end
    end

    context 'Invalid scenarios' do
      it 'should fail to logout' do
        token = 'Invalid token'
        header 'Authorization', "Bearer #{token}"
        delete('/users/logout', {}.to_json, headers)

        expect(last_response.status).to eq(401)
        expect(json_response['error']).to eq('Unauthorized')
      end
    end
  end
end
