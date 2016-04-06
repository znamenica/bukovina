class AddAlphabethCodeToManyTables < ActiveRecord::Migration
   def change
      change_table :names do |t|
         t.string :alphabeth_code, null: false, default: 0
         t.index ["text", "type", "alphabeth_code"], unique: true
         t.remove_index ["text", "type", "language_code"] ;end

      change_table :descriptions do |t|
         t.string :alphabeth_code, null: false, default: 0
         t.remove_index ["describable_id", "describable_type", "language_code"]
         t.index ["describable_id", "describable_type", "alphabeth_code"],
            unique: true, name: "describable_alphabeth_index" ;end

      change_table :links do |t|
         t.string :alphabeth_code, null: false, default: 0 ;end

      change_table :services do |t|
         t.string :alphabeth_code, null: false, default: 0
         t.index ["name", "alphabeth_code"], unique: true
         t.remove_index ["name", "language_code"] ;end

      change_table :chants do |t|
         t.string  :title
         t.string :alphabeth_code, null: false, default: 0

         t.index ["text", "alphabeth_code"], unique: true
         t.remove_index ["text", "language_code"] ;end ;end ;end
