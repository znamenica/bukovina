class FixMemoes < ActiveRecord::Migration[4.2]
   def change
      change_table :memoes do |t|
         t.string :bind_kind, null: false
         t.integer :bond_to_id
         t.belongs_to :event, null: false
         t.rename :happened_at, :add_date
         t.rename :date, :year_date
         t.remove :memory_id
         t.remove :before
         t.remove :after
         t.remove :inevening ;end

      change_column_null :memoes, :calendary_id, false

      add_index :memoes, %i(calendary_id year_date)
      add_index :memoes, %i(calendary_id event_id year_date), unique: true
      add_index :memoes, %i(bond_to_id bind_kind)

      drop_table :event_memoes
      drop_table :mentions ;end;end
