require_relative './config/environment'
require 'sinatra/activerecord'
environment = ENV['RACK_ENV'] || 'development'
namespace :db do
  task :migrate do
    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || YAML.load_file('./config/database.yml')[environment])
    ActiveRecord::MigrationContext.new('db/migrate/',
                                       ActiveRecord::SchemaMigration).migrate(ENV['VERSION']&.to_i)
  end

  task :create do
    db_config = YAML.load_file('./config/database.yml')[environment]
    ActiveRecord::Base.establish_connection(db_config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.create_database(db_config['database'])
  end
end

task :console do
  require 'pry'
  Pry.start
end
