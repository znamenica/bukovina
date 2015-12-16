require 'bukovina'
require 'cucumber'

require 'bundler/gem_tasks'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber) do |t|
   t.cucumber_opts = "features --format pretty"
end

namespace :db do
   desc 'Load DB Config'
   task :load_config do
      ActiveRecord::Tasks::DatabaseTasks.database_configuration =
         Rails.application.config.database_configuration
   end

   desc 'Load Environment'
   task :environment do
      require_relative 'config/environment.rb'
   end

   desc 'Load Config'
   task :load_config => :environment do
      Rails.application
   end

   desc 'Validate seed'
   task :validate => :load_config do
      app = Rails.application
      app.validate
      if !app.errors.empty?
         app.errors.each do |e|
            STDERR.puts e
         end
      end
   end
end

task 'db:seed' => [:load_config]

load "active_record/railties/databases.rake"

task :default => ['db:create', 'db:migrate', 'db:seed', :cucumber]
