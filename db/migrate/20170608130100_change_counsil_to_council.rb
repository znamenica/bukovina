class ChangeCounsilToCouncil < ActiveRecord::Migration[4.2]
   def change
      change_table :memories do |t|
         t.rename :counsil, :council ;end

      change_table :calendaries do |t|
         t.rename :counsil, :council ;end;end;end
