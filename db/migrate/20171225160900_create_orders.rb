class CreateOrders < ActiveRecord::Migration[4.2]
   def change
      create_table :orders do |t|
         t.string :order
         t.string :text
         t.string :alphabeth_code
         t.string :language_code ;end
      
      add_index :orders, :text
      add_index :orders, :order
      add_index :orders, %i(order alphabeth_code), unique: true
      add_index :orders, %i(text alphabeth_code language_code) ;end;end
