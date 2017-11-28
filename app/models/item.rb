class Item < ActiveRecord::Base
   belongs_to :item_type
   has_many :events

   accepts_nested_attributes_for :item_type

   scope :with_token, -> token { unscoped.joins( :item_type ).merge(ItemType.with_token( token )) }

   def description_for language_code
      item_type.description_for(language_code) ;end;end
