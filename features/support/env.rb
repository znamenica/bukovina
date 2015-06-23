require 'config/environment'

require 'pry'
require 'database_cleaner'
require 'rspec/expectations'
require 'shoulda-matchers'

ENV[ 'RAILS_ENV' ] = 'cucumber'
DatabaseCleaner.strategy = :truncation

Rails.application

Shoulda::Matchers.configure do |config|
   config.integrate do |with|
      with.test_framework :rspec_exp
      with.library :active_model
      with.library :active_record
   end
end

at_exit { DatabaseCleaner.clean }
