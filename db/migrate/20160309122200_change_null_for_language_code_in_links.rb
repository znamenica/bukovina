class ChangeNullForLanguageCodeInLinks < ActiveRecord::Migration
   def change
      change_column_null :links, :language_code, true ; end ; end
