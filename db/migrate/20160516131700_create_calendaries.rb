class CreateCalendaries < ActiveRecord::Migration
   def change
      create_table :calendaries do |t|
         t.string :author
         t.string :date
         t.string :language_code
         t.string :alphabeth_code
         t.string :slug, unique: true

         t.timestamps null: false ;end ;end ;end
