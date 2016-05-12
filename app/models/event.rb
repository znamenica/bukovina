class Event < ActiveRecord::Base
   include Informatible

   belongs_to :memory

   # synod : belongs_to
   # czin: has_one/many
#   has_many :places

   default_scope -> { order(:created_at) }

   validates :memory_id, :type, presence: true ;end
