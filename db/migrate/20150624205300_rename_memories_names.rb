class RenameMemoriesNames< ActiveRecord::Migration
   def change
      rename_table :memories_names, :memory_names
   end
end

