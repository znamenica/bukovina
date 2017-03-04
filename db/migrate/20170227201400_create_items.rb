class CreateItems < ActiveRecord::Migration
   def change
      create_table :items do |t|
         t.belongs_to :item_type, null: false

         t.timestamps null: false ;end;end;end
