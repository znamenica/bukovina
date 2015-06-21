require "bundler/gem_tasks"

namespace :db do
   desc 'Load Environment'
   task :env do
      require 'config/environment.rb'
   end

   desc "Migrate the database"
   task drop: :env do
      ActiveRecord::Migration.drop_table :memories
   end

   desc "Migrate the database"
   task migrate: :env do
      ActiveRecord::Migrator.migrate 'lib/db/migrate',
         ENV["VERSION"] && ENV["VERSION"].to_i || nil
   end

   desc "Seed the database"
   task seed: :env do
      Dir.glob( 'памяти/**/память.*.yml' ).each do |f|
         puts "Память: #{f}"
         m = YAML.load( File.open( f ) )
#         Memory.create do |memory|
#            memory.name = m
#         end
      end
   end
end
