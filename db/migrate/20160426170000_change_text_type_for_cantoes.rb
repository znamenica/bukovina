class ChangeTextTypeForCantoes < ActiveRecord::Migration
   def change
      change_column :cantoes, :text, :text ;end ;end
