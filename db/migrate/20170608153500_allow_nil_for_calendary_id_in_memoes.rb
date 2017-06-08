class AllowNilForCalendaryIdInMemoes < ActiveRecord::Migration[4.2]
   def change
      change_column_null :memoes, :calendary_id, true ;end;end
