class CreateMagnifications < ActiveRecord::Migration
   def change
      create_table :magnifications do |t|
         t.string  :text, null: false
         t.integer :language_code, null: false

         t.timestamps null: false ;end

      add_index :magnifications, [ :text, :language_code ], unique: true ;end ;end
