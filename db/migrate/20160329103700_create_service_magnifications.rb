class CreateServiceMagnifications < ActiveRecord::Migration
   def change
      create_table :service_magnifications do |t|
         t.belongs_to  :service, null: false
         t.belongs_to  :magnification, null: false ;end

      add_index :service_magnifications, [ :service_id, :magnification_id ],
         unique: true, name: :service_magnifications_index ;end ;end
