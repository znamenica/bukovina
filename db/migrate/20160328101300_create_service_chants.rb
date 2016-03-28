class CreateServiceChants < ActiveRecord::Migration
   def change
      create_table :service_chants do |t|
         t.belongs_to  :service, null: false
         t.belongs_to  :chant, null: false ;end

      add_index :service_chants, [ :service_id, :chant_id ], unique: true ;end ;end
