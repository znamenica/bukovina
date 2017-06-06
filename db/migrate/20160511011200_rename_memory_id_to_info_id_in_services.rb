class RenameMemoryIdToInfoIdInServices < ActiveRecord::Migration[4.2]
   def change
      rename_column :services, :memory_id, :info_id
      add_column :services, :info_type, :string ;end ;end
