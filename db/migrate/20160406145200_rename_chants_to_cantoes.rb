class RenameChantsToCantoes < ActiveRecord::Migration
   def change
      rename_table :chants, :cantoes
      
      change_table :cantoes do |t|
         t.index [:title, :alphabeth_code], unique: true; end ;end ;end
