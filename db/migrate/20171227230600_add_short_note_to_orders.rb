class AddShortNoteToOrders < ActiveRecord::Migration[4.2]
   def change
      change_table :orders do |t|
         t.string :short_note
         t.string :note ;end;end;end
