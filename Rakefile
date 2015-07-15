require "bundler/gem_tasks"
load "active_record/railties/databases.rake"

namespace :db do
   desc 'Load Environment'
   task :environment do
      require 'config/environment.rb'
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
