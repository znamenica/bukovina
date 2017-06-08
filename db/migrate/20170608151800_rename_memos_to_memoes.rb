class RenameMemosToMemoes < ActiveRecord::Migration[4.2]
   def change
      rename_table :memos, :memoes ;end;end
