class Event < ActiveRecord::Base
   include Informatible

   belongs_to :memory
   belongs_to :place

   # synod : belongs_to
   # czin: has_one/many

   default_scope -> { order(:created_at) }

   validates :memory_id, :type, presence: true ;end
