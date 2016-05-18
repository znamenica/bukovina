class Mention < ActiveRecord::Base
   belongs_to :calendary
   belongs_to :event

   delegate :memory, to: :event

   validates :calendary_id, :event_id, :year_date, presence: true ;end
