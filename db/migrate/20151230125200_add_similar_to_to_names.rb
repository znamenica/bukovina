class AddSimilarToToNames < ActiveRecord::Migration
   def change
      change_table :names do |t|
         t.belongs_to :similar_to ; end ; end ; end
