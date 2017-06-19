namespace :import do
   desc "Import calendaries"
   task calendaries: :environment do
      Bukovina::Tasks.import_calendaries

      true; end

   desc "Import memories"
   task memories: %i(environment db:environment:set) do
      Bukovina::Tasks.import_memories

      true; end;end
