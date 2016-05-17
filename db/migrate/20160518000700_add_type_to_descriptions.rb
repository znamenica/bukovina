class AddTypeToDescriptions < ActiveRecord::Migration
   def change
      change_table :descriptions do |t|
         t.string :type ;end ;end ;end
