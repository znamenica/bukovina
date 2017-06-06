class CreateMemories < ActiveRecord::Migration[4.2]
   def change
      create_table :memories do |t|
         t.string :short_name, unique: true

         t.timestamps null: false
      end

      add_index :memories, :short_name, unique: true ;end;end
