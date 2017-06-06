class ChangeTextTypeForCantoes < ActiveRecord::Migration[4.2]
   def change
      change_column :cantoes, :text, :text ;end ;end
