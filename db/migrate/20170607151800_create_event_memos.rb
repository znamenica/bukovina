class CreateEventMemos < ActiveRecord::Migration[4.2]
   def change
      create_table :event_memos do |t|
         t.string :type_class
         t.string :type_number
         t.belongs_to :memo, null: false
         t.belongs_to :event ;end;end;end
