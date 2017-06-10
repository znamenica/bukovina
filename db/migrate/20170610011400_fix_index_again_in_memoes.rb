class FixIndexAgainInMemoes < ActiveRecord::Migration[4.2]
   def change
      change_table :memoes do |t|
         t.remove_index name: :index_memoes_on_memory_calendary_and_happened_at

         t.index ["memory_id", "calendary_id", "date"],
            name: "index_memoes_on_memory_calendary_and_date", unique: true ;end;end;end
