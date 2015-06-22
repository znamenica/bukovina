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
end
