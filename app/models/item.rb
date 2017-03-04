class Item < ActiveRecord::Base
   belongs_to :item_type
   has_many :events, foreign_key: :object_id ;end
