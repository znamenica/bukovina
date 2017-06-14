class ChangeSubjectInEvents < ActiveRecord::Migration[4.2]
   def change
      change_table :events do |t|
         t.remove :subject
         t.remove :object_id
         t.belongs_to :item

         # t.remove_index name: "index_events_on_subject_and_type_and_memory_id" # for SQLite only
         t.index ["type", "memory_id", "item_id"],
                 name: "index_events_on_item_id_and_type_and_memory_id" ; end;end;end
