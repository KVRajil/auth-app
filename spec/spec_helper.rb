ENV['RACK_ENV'] = 'test'
require 'rack/test'
require_relative '../config/environment'
require 'factory_bot'
require 'database_cleaner'
require_relative './factories/users'

def app
  Rack::Builder.parse_file(File.expand_path('../config.ru', __dir__)).first
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
