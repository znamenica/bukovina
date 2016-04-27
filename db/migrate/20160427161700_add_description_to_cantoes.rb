class AddDescriptionToCantoes < ActiveRecord::Migration
   def change
      change_table :cantoes do |t|
         t.string :author
         t.string :description ;end ;end ;end
