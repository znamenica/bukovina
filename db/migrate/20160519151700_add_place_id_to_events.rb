class AddPlaceIdToEvents < ActiveRecord::Migration
   def change
      change_table :events do |t|
         t.belongs_to :place ;end ;end ;end
