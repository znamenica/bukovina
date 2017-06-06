class AddObjectIdToEvents < ActiveRecord::Migration[4.2]
   def change
      change_table :events do |t|
         t.integer :object_id ;end;end;end
