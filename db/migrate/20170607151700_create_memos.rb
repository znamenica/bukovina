class CreateMemos < ActiveRecord::Migration[4.2]
   def change
      create_table :memos do |t|
         t.string :happened_at, index: true
         t.string :date, index: true
         t.integer :before
         t.integer :after
         t.integer :ineveningy
         t.belongs_to :memory, null: false
         t.belongs_to :calendary, null: false

         t.index [ :memory_id, :calendary_id ], unique: true ;end;end;end
