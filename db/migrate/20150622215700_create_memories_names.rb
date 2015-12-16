class CreateMemoriesNames < ActiveRecord::Migration
   def change
      create_table :memories_names do |t|
         t.belongs_to :memory, null: false
         t.belongs_to :name, null: false
      end

      add_index :memories_names, [ :memory_id, :name_id ], unique: true
   end
end

