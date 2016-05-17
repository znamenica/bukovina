class RemoveIndexInDescriptions < ActiveRecord::Migration
   def change
      remove_index :descriptions, name: "describable_alphabeth_index"
      add_index :descriptions, ["describable_id", "describable_type",
         "alphabeth_code", "text"], name: "describable_alphabeth_index",
         unique: true ;end ;end
