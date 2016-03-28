class CreateServices < ActiveRecord::Migration
   def change
      create_table :services do |t|
         t.string  :name, null: false
         t.integer :language_code, null: false
         t.belongs_to :memory, null: false

         t.string  :type
         t.timestamps null: false ;end

      add_index :services, [ :name, :language_code ], unique: true ;end ;end
