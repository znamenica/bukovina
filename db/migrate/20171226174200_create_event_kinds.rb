class CreateEventKinds < ActiveRecord::Migration[4.2]
   def change
      create_table :event_kinds do |t|
         t.string :kind
         t.string :text
         t.string :alphabeth_code
         t.string :language_code ;end
      
      add_index :event_kinds, :text
      add_index :event_kinds, :kind
      add_index :event_kinds, %i(kind alphabeth_code), unique: true
      add_index :event_kinds, %i(text alphabeth_code language_code) ;end;end
