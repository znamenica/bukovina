class AddFieldsToCalendaries < ActiveRecord::Migration[4.2]
   def change
      change_table :calendaries do |t|
         t.index :slug, unique: true

         t.remove :author

         t.belongs_to :place, optional: true
         t.string :author_name
         t.string :counsil ;end;end;end
