namespace :import do
   desc "Import calendaries"
   task calendaries: :environment do
      Bukovina::Tasks.import_calendaries

      true; end

   desc "import memories"
   task memories: %i(environment db:environment:set) do
      Bukovina::Tasks.import_memories

      true; end

   desc "import orders"
   task orders: %i(environment db:environment:set) do
      Bukovina::Tasks.import_orders

      true; end

   desc "import event kinds"
   task event_kinds: %i(environment db:environment:set) do
      Bukovina::Tasks.import_event_kinds

      true; end;end

task import: %(import:orders import:event_kinds import:calendaries import:memories)
