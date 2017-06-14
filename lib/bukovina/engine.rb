module Bukovina
   class Engine < Rails::Engine
      initializer "bukovina.load_app_instance_data" do |app|

         require Bukovina::Engine.root.join('app/models/concern/language').to_s
         require Bukovina::Engine.root.join('app/models/concern/default_key').to_s
         require Bukovina::Engine.root.join('app/models/concern/informatible').to_s
         require Bukovina::Engine.root.join('app/models/concern/validation_cancel').to_s
#
#         initializers 'engine_name.include_concerns' do
#            ActionDispatch::Reloader.to_prepare do
#               Memory.send(:extend, Language)
#            end
#         end
#
         app.class.configure do 
            # Autoload from app/models/concern directory
            config.autoload_paths = config.autoload_paths.dup << Bukovina::Engine.root.join('app/models/concern').to_s
            # Pull in all the migrations from Commons to the application
            config.paths['db/migrate'].concat(Bukovina::Engine.paths['db/migrate'].existent) ;end;end
#         initializer "commons.load_static_assets" do |app|
#            app.middleware.use ::ActionDispatch::Static, "#{root}/public"
#         end
        isolate_namespace Bukovina
            end;end
