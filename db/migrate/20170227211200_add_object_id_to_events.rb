class AddObjectIdToEvents < ActiveRecord::Migration
   def change
      change_table :events do |t|
         t.integer :object_id ;end;end;end
