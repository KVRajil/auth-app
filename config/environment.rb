require 'bundler/setup'
Bundler.require
Dotenv.load

require "#{File.dirname(__FILE__)}/../app"
Dir[File.join(__dir__, '..', 'config', 'initializers', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, '..', 'app', 'lib', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, '..', 'app', 'models', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, '..', 'app', 'mailers', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, '..', 'app', 'controllers', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, '..', 'app', 'services', '**', '*.rb')].sort.each { |file| require file }
