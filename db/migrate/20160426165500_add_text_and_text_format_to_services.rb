class AddTextAndTextFormatToServices < ActiveRecord::Migration
   def change
      change_table :services do |t|
         t.text :text
         t.string :text_format ;end ;end ;end
