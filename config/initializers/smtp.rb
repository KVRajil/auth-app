Pony.options = {
  from: ENV['SMTP_FROM'],
  via: :smtp,
  via_options: {
    address: ENV['SMTP_ADDRESS'],
    port: ENV['SMTP_PORT'],
    enable_starttls_auto: true,
    user_name: ENV['SMTP_USER_NAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: :plain,
    domain: ENV['HOST']
  }
}
