class ChangeTypeForLanguageCode < ActiveRecord::Migration
   def change
      change_table :cantoes do |t|
         t.change :language_code, :string ;end

      change_table :descriptions do |t|
         t.change :language_code, :string ;end

      change_table :links do |t|
         t.change :language_code, :string ;end

      change_table :names do |t|
         t.change :language_code, :string ;end

      change_table :services do |t|
         t.change :language_code, :string ;end ;end ;end
