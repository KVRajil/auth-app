# README

A simple AuthApp using Sinatra


Features
1. User sign up, login and logout
2. Generate & verify OTP
3. Update password & toggle 2FA
4. Throttling and rate limiting using rack-attack


Ruby version - 3.2.2

Sinatra version - 3.0.6




Installation & Setup:

    Clone the project & cd to root path.
    Copy .env.example to .env and replace env sample values with the actual values
    Db setup - RACK_ENV=development rake db:create & rake db:migrate
    Start the Sinatra app using rackup -p 3000 .
    Run the RSpec tests with rspec spec/ (RACK_ENV=test rake db:create & rake db:migrate).

App Workflow:

    Register using email id & password (the password should be strong).
    Click on the confirmation email link to verify the account.
    Log in to create a temporary JWT and use that token for generating and verifying OTP.
    Generate & verify the OTP (requires the temporary JWT token).
    Once the OTP is verified, use the JWT token for authenticating other actions.
    Enabling or disabling 2FA  requires the JWT token + current password + the newly generated OTP.
    Updating the password      requires the JWT token + current password + the newly generated OTP.
    Enabling the 2fa API will give you the OTP secret which can be used to configure the authenticator app.
    JWT token will be revoked once you logout or expires after 5 minutes.
    Note - OTP will be send through the registered email id & OTP valid only for 90 seconds.


Security Best Practices(TODO):

    Use Secret Management System.
    Periodic Key Rotation.
    Use HTTPS protocol(Rack SSL Enforcer).


Rake Tasks:

    RACK_ENV=development rake db:create
    RACK_ENV=development rake db:migrate
    rake console


CURL Requests

1. Registration
   ```bash
   curl --location 'localhost:3000/users/signup' \
   --header 'Content-Type: application/json' \
   --data-raw '{ "email": "rajilkva2z@gmail.com", "password": "Test@1234", "password_confirmation": "Test@1234"}'


2. Confirm Email
   ```bash
   curl --location 'http://localhost:3000/users/confirmations/AccNSNPWb1tQcJcyenlIHA'

3. Resend Confirmation Email
   ```bash
   curl --location 'localhost:3000/users/confirmations' \
   --header 'Content-Type: application/json' \
   --data-raw '{"email": "rajilkva2z@gmail.com", "password": "Test@1234"}'

4. Login
   ```bash
   curl --location 'localhost:3000//users/login' \
   --header 'Content-Type: application/json' \
   --data-raw '{"email": "rajilkva2z@gmail.com", "password": "Test@1234"}'


5. Generate OTP
   ```bash
   curl --location --request POST 'localhost:3000/users/generate_otp' \
   --header 'Content-Type: application/json' \
   --header 'Accept: application/json' \
   --header 'Authorization: Bearer Token' \
   --data ''

6. Verify OTP
   ```bash
   curl --location 'localhost:3000/users/verify_otp' \
   --header 'Content-Type: application/json' \
   --header 'Accept: application/json' \
   --header 'Authorization: Bearer Token' \
   --data '{"otp": "388409"}'

7. Toggle 2FA
   ```bash
   curl --location --request PATCH 'localhost:3000/users/toggle_2fa' \
   --header 'Content-Type: application/json' \
   --header 'Accept: application/json' \
   --header 'Authorization: Bearer Token' \
   --data-raw '{"password": "Test@1234", "otp": "544608", "enable_2fa": false}'

8. Update Password
   ```bash
   curl --location --request PATCH 'localhost:3000/users/passwords' \
   --header 'Content-Type: application/json' \
   --header 'Accept: application/json' \
   --header 'Authorization: Bearer Token' \
   --data-raw '{"current_password": "Test@1234", "new_password": "TestNew@1234", "otp": "275073"}'

5. Logout
   ```bash
   curl --location --request DELETE 'localhost:3000/users/logout' \
   --header 'Content-Type: application/json' \
   --header 'Accept: application/json' \
   --header 'Authorization: Bearer Token' \
   --data ''
