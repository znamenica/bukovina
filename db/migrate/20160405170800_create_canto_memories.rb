class CreateCantoMemories < ActiveRecord::Migration
   def change
      create_table :canto_memories do |t|
         t.belongs_to :canto, null: false
         t.belongs_to :memory, null: false ;end

      add_index :canto_memories, [ :canto_id, :memory_id ],
         unique: true, name: :canto_memories_index ;end ;end
