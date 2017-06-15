module Bukovina
   class Engine < Rails::Engine
      initializer "bukovina.load_app_instance_data" do |app|
         autoload_paths = app.instance_variable_get(:@_all_autoload_paths)
         paths = Dir.glob("#{Bukovina::Engine.root.join("app/models/**/*")}").select { |f| File.directory?(f) }
         paths << Bukovina::Engine.root.join("app/validators")

         paths.each do |dir|
            ActiveSupport::Dependencies.autoload_paths << dir
         end

         # Pull in all the migrations from Commons to the application
         config.paths['db/migrate'].concat(Bukovina::Engine.paths['db/migrate'].existent) ;end

      isolate_namespace Bukovina ;end;end if defined?(Rails)
