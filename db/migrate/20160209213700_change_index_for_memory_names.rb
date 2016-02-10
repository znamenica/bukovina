class ChangeIndexForMemoryNames < ActiveRecord::Migration
   def change
      change_table :memory_names do |t|
         t.remove_index column: [ :memory_id, :name_id ], unique: true
         t.index [ :memory_id, :name_id, :state ], unique: true
         end ; end ; end
