class Place < ActiveRecord::Base
   has_many :descriptions, as: :describable
   has_many :events

   validates :descriptions, presence: true
   validates :descriptions, associated: true ;end
