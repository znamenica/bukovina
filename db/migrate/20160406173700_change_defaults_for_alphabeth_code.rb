class ChangeDefaultsForAlphabethCode < ActiveRecord::Migration
   def change
      change_table :cantoes do |t|
         t.change_default :alphabeth_code, nil ;end

      change_table :descriptions do |t|
         t.change_default :alphabeth_code, nil ;end

      change_table :links do |t|
         t.change_default :alphabeth_code, nil ;end

      change_table :names do |t|
         t.change_default :alphabeth_code, nil ;end

      change_table :services do |t|
         t.change_default :alphabeth_code, nil ;end ;end ;end
