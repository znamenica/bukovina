class MakeTextInSlugsUnique < ActiveRecord::Migration[4.2]
   def change
      remove_index(:slugs, column: ["text"], name: "index_slugs_on_text")
      add_index :slugs, ["text"], name: "index_slugs_on_text", unique: true ;end;end
