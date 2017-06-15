namespace :import do
   desc "Import calendaries"
   task calendaries: :environment do
      Bukovina::Tasks.import_calendaries

      true; end

   desc "Import memories"
   task memories: :environment do
      Bukovina::Tasks.import_calendaries

      true; end;end
