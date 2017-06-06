class ChangeNullForLanguageCodeInLinks < ActiveRecord::Migration[4.2]
   def change
      change_column_null :links, :language_code, true ; end ; end
