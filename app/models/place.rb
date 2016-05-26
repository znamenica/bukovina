class Place < ActiveRecord::Base
   has_many :descriptions, as: :describable
   has_many :events

   accepts_nested_attributes_for :descriptions

   validates :descriptions, presence: true
   validates :descriptions, associated: true ;end
