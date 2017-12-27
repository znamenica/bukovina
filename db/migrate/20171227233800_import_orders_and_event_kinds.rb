class ImportOrdersAndEventKinds < ActiveRecord::Migration[4.2]
   def up
      Bukovina::Tasks.import_orders
      Bukovina::Tasks.import_event_kinds ;end
   
   def down
      Order.destroy_all
      EventKind.destroy_all ;end;end
