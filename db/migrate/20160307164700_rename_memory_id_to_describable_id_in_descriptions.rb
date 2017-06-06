class RenameMemoryIdToDescribableIdInDescriptions < ActiveRecord::Migration[4.2]
   def change
      change_table :descriptions do |t|
         t.remove_index [ "memory_id", "language_code" ]

         t.rename :memory_id, :describable_id
         t.string :describable_type

         t.index [ "describable_id", "describable_type", "language_code" ], unique: true,
            name: 'index_descriptions_on_describable_and_language_code' ; end


      Description.update_all( describable_type: 'Memory' )

      change_column_null :descriptions, :describable_id, false
      change_column_null :descriptions, :describable_type, false ; end ; end
