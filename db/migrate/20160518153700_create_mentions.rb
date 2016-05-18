class CreateMentions < ActiveRecord::Migration
   def change
      create_table :mentions do |t|
         t.belongs_to :calendary, null: false
         t.belongs_to :event, null: false
         t.string :year_date, null: false
         t.string :add_date

         t.timestamps null: false ;end

      add_index :mentions, [:calendary_id, :event_id, :year_date],
         name: :dated_calendary_event_index, unique: true ;end ;end
