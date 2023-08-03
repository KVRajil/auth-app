require 'spec_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, email: 'test@gmail.com', password: 'Test@123', password_confirmation: 'Test@123') }

  context 'validations' do
    it 'ensures email presence' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'ensures email uniqueness' do
      new_user = user.dup
      expect(new_user).to_not be_valid
    end

    it 'ensures password strength' do
      new_user = User.new(email: 'another_test@gmail.com', password: '123456', password_confirmation: '123456')
      expect(new_user).to_not be_valid
    end

    it 'ensures password & password_confirmation match' do
      new_user = User.new(email: 'another_test@gmail.com', password: 'Test@123', password_confirmation: 'Test@12356')
      expect(new_user).to_not be_valid
    end
  end

  describe 'update_confirmation_token' do
    it 'generates and saves a new confirmation token' do
      user.confirmation_token = nil
      expect(user.confirmation_token).to be_nil

      user.update_confirmation_token

      expect(user.confirmation_token).not_to be_nil
    end
  end

  describe 'generate_confirmation_token' do
    it 'generates a random confirmation token' do
      user.confirmation_token = nil
      token = user.send(:generate_confirmation_token)

      expect(token).not_to be_nil
      expect(user.confirmation_token).to eq(token)
    end
  end

  describe 'generate_otp_secret' do
    it 'generates a random OTP secret' do
      user.send(:generate_otp_secret)

      expect(user.otp_secret).not_to be_nil
      expect(user.otp_secret.length).to eq(32)
    end
  end
end
