class RetypeFeasiblyInMemoryNames < ActiveRecord::Migration[4.2]
   def change
      change_table :names do |t|
         t.remove :type ;end

      change_table :memory_names do |t|
         t.boolean :feasible, default: false, null: false ;end

      MemoryName.where(feasibly: 'feasible').update(feasible: true)

      remove_column :memory_names, :feasibly ;end;end
