class RenameEventMemosToEventMemoes < ActiveRecord::Migration[4.2]
   def change
      rename_table :event_memos, :event_memoes ;end;end
