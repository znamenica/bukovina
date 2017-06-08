class AddFieldsToEvents < ActiveRecord::Migration[4.2]
   def change
      change_table :events do |t|
         t.integer :type_number
         t.string :about_string
         t.string :tezo_string
         t.string :order
         t.string :council ;end;end;end
