class ApplicationMailer
  def mail(to:, subject:, body:)
    Pony.mail(to: to, subject: subject, body: body)
  end
end
