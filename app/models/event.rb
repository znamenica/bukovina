# type[string]   наименование класса события
# memory_id[int] id памяти, событие которой произошло
# place_id[int]  id места, где произошло событие
# object_id[int] id объекта, к которому применяется событие
class Event < ActiveRecord::Base
   extend Informatible

   belongs_to :memory
   belongs_to :place, optional: true

   # synod : belongs_to
   # czin: has_one/many
   default_scope -> { order(:created_at) }

   accepts_nested_attributes_for :place

   validates :memory_id, :type, presence: true ;end
