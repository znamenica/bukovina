require 'spork'

Spork.prefork do
   require_relative '../../config/environment'

   require 'pry'
   require 'database_cleaner'
   require 'database_cleaner/cucumber'
   require 'rspec/expectations'
   require 'shoulda-matchers'
   require 'factory_girl'
   require 'ffaker'
   require 'fileutils'

   ENV[ 'RAILS_ENV' ] ||= 'cucumber'
   Rails.application

   DatabaseCleaner.strategy = :truncation

   Shoulda::Matchers.configure do |config|
      config.integrate do |with|
         with.test_framework :rspec_exp
         with.library :active_model
         with.library :active_record ; end ; end

   FactoryGirl.definition_file_paths = %w(features/factories)
   FactoryGirl.lint
   World( FactoryGirl::Syntax::Methods )

   Around do |_scenario, block|
      DatabaseCleaner.cleaning( &block ) ; end

   Before do
      @owd = Dir.pwd
      @workdir = Dir.mktmpdir ; end

   After do
      Dir.chdir( @owd )
      FileUtils.remove_entry_secure( @workdir ) ; end

   at_exit do
      DatabaseCleaner.clean ; end ; end
