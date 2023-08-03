class OtpService
  attr_reader :totp, :user

  def initialize(user)
    @user = user
    @totp = ROTP::TOTP.new(@user.otp_secret, interval: 90)
  end

  def generate
    totp.now
  end

  def verify(otp)
    last_otp_at = totp.verify(otp, after: user.last_otp_at)
    user.update!(last_otp_at: last_otp_at) if last_otp_at
    last_otp_at
  end

  def generate_and_email
    otp = generate
    UserMailer.new.send_otp(user, otp)
  end
end
