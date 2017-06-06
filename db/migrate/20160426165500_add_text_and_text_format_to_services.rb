class AddTextAndTextFormatToServices < ActiveRecord::Migration[4.2]
   def change
      change_table :services do |t|
         t.text :text
         t.string :text_format ;end ;end ;end
