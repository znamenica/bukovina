class AddDescriptionToCantoes < ActiveRecord::Migration[4.2]
   def change
      change_table :cantoes do |t|
         t.string :author
         t.string :description ;end ;end ;end
