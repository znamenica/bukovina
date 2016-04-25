class ChangeNullForAlphabethCode < ActiveRecord::Migration
   def change
      change_column_null :links, :alphabeth_code, true ;end ;end
