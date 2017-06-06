class CreateEvents < ActiveRecord::Migration[4.2]
   def change
      create_table :events do |t|
         t.string :happened_at
         t.string :subject # or belongs_to
         t.belongs_to :memory, null: false

         t.string :type, null: false
         t.timestamps null: false ;end

      add_index :events, [ :subject, :type, :memory_id ] ;end ;end
