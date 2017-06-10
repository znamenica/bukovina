class FixIndexInMemoes < ActiveRecord::Migration[4.2]
   def change
      change_table :memoes do |t|
         t.remove_index name: :index_memoes_on_memory_id_and_calendary_id

         t.index ["memory_id", "calendary_id", "happened_at"],
            name: "index_memoes_on_memory_calendary_and_happened_at", unique: true ;end;end;end
