class AddModeToMemoryNames < ActiveRecord::Migration
   def change
      change_table :memory_names do |t|
         t.integer :mode ; end ; end ; end
