class ItemType < ActiveRecord::Base
   has_many :items
   has_many :descriptions, as: :describable

   accepts_nested_attributes_for :descriptions

   validates :descriptions, presence: true
   validates :descriptions, associated: true ;end
