require 'spork'

Spork.prefork do
   require_relative '../../config/environment'

   require 'pry'
   require 'database_cleaner'
   require 'rspec/expectations'
   require 'shoulda-matchers'
   require 'factory_girl'
   require 'ffaker'

   ENV[ 'RAILS_ENV' ] ||= 'cucumber'
   DatabaseCleaner.strategy = :truncation

   Rails.application

   Shoulda::Matchers.configure do |config|
      config.integrate do |with|
         with.test_framework :rspec_exp
         with.library :active_model
         with.library :active_record
      end
   end

   FactoryGirl.definition_file_paths = %w(features/factories)
   FactoryGirl.lint
   World(FactoryGirl::Syntax::Methods)

   at_exit { DatabaseCleaner.clean }
end

