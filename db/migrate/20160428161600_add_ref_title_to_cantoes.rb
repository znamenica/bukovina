class AddRefTitleToCantoes < ActiveRecord::Migration
   def change
      change_table :cantoes do |t|
         t.string :ref_title
         t.remove_index [:text, :alphabeth_code]
         t.remove_index [:title, :alphabeth_code]
         t.index [:title, :language_code] ;end
      change_column_null :cantoes, :text, true ;end ;end
