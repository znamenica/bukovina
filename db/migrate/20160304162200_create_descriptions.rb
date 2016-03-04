class CreateDescriptions < ActiveRecord::Migration
   def change
      create_table :descriptions do |t|
         t.string :text, null: false
         t.integer :language_code, null: false
         t.belongs_to :memory, null: false

         t.timestamps null: false
      end

      add_index :descriptions, [ :text, :language_code ], unique: true
      add_index :descriptions, [ :memory_id, :language_code ], unique: true
   end
end

