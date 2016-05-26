class Event < ActiveRecord::Base
   extend Informatible

   belongs_to :memory
   belongs_to :place

   # synod : belongs_to
   # czin: has_one/many
   default_scope -> { order(:created_at) }

   accepts_nested_attributes_for :place

   validates :memory_id, :type, presence: true ;end
