class AddBondToIdToMemories < ActiveRecord::Migration[4.2]
   def change
      change_table :memories do |t|
         t.integer :bond_to_id
         t.remove :view_string ;end

      add_index :memories, %i(bond_to_id) ;end;end
