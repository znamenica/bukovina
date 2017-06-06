class RenameMemoriesNames< ActiveRecord::Migration[4.2]
   def change
      rename_table :memories_names, :memory_names ;end;end
