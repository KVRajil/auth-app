class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, if: :password_changed?
  validates :is_two_factor_enabled, inclusion: { in: [true, false] }

  validate :strong_password

  before_create :generate_confirmation_token, :generate_otp_secret

  def update_confirmation_token
    self.confirmation_token = generate_confirmation_token
    save
  end

  private

  def strong_password
    return if password.blank?

    error = 'must include at least 8 characters, one digit, one lowercase letter, one uppercase letter, and one special character.'
    errors.add(:password, error) unless password.match?(/^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*\W).{8,}$/)
  end

  def password_changed?
    password.present? || new_record?
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
  end

  def generate_otp_secret
    self.otp_secret = ROTP::Base32.random_base32
  end
end
