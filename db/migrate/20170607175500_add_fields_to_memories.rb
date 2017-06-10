class AddFieldsToMemories < ActiveRecord::Migration[4.2]
   def change
      change_table :memories do |t|
         t.belongs_to :cover
         t.string :view_string
         t.string :short
         t.string :quantity
         t.string :order, index: true
         t.string :counsil, index: true ;end;end;end
