class RenameServiceChantsToServiceCantoes < ActiveRecord::Migration
   def change
      rename_table :service_chants, :service_cantoes
      
      change_table :service_cantoes do |t|
         t.remove_index ["service_id", "chant_id"]

         t.rename :chant_id, :canto_id

         t.index ["service_id", "canto_id"], unique: true; end ;end ;end
