class AddPersonNameToEvents < ActiveRecord::Migration[4.2]
   def change
      change_table :events do |t|
         t.string :person_name ;end;end;end
