class UserMailer < ApplicationMailer
  def confirmation_email(user)
    body = "Confirmation link is #{ENV['HOST']}/users/confirmations/#{user.confirmation_token}"
    mail(to: user.email, subject: 'Account Confirmation', body: body)
  end

  def send_otp(user, otp)
    body = "OTP is #{otp}. Valid for 90 seconds."
    mail(to: user.email, subject: 'One time password', body: body)
  end
end
