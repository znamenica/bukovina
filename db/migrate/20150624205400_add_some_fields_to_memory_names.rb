class AddSomeFieldsToMemoryNames < ActiveRecord::Migration[4.2]
   def change
      add_column :memory_names, :state, :integer
      add_column :memory_names, :feasibly, :integer, default: 0, null: false
      add_column :memory_names, :created_at, :timestamp
      add_column :memory_names, :updated_at, :timestamp

      change_column_null :memory_names, :created_at, false
      change_column_null :memory_names, :updated_at, false ;end;end
