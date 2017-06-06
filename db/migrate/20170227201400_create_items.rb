class CreateItems < ActiveRecord::Migration[4.2]
   def change
      create_table :items do |t|
         t.belongs_to :item_type, null: false

         t.timestamps null: false ;end;end;end
