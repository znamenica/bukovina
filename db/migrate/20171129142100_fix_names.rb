class FixNames < ActiveRecord::Migration[4.2]
   def change
      change_table :names do |t|
         t.integer :root_id
         t.string :bind_kind, null: false
         t.rename :similar_to_id, :bond_to_id ;end

      add_index :names, %i(root_id)
      add_index :names, %i(text alphabeth_code), unique: true
      add_index :names, %i(bond_to_id bind_kind) ;end;end
