class AddBaseYearToMemories < ActiveRecord::Migration[4.2]
   def change
      change_table :memories do |t|
         t.integer :base_year, index: true ;end;end;end
