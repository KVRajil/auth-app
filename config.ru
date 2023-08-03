require_relative 'config/environment'
# use Rack::MethodOverride
# use Rack::JSONBodyParser
use Rack::Attack
map '/users' do
  use Users::RegistrationsController
  use Users::ConfirmationsController
  use Users::SessionsController
  use Users::PasswordsController
  use Users::TwoFactorAuthenticationController
end
run AuthApp
