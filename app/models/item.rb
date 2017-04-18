class Item < ActiveRecord::Base
   belongs_to :item_type
   has_many :events

   accepts_nested_attributes_for :item_type ;end
