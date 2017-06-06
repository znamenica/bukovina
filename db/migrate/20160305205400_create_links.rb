class CreateLinks < ActiveRecord::Migration[4.2]
   def change
      create_table :links do |t|
         t.string :url, null: false
         t.integer :language_code, null: false
         t.belongs_to :memory, null: false

         t.string :type, null: false
         t.timestamps null: false ; end ; end ; end
