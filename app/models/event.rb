# type[string]   наименование класса события
# memory_id[int] id памяти, событие которой произошло
# place_id[int]  id места, где произошло событие
# item_id[int]   id предмета, к которому применяется событие
class Event < ActiveRecord::Base
   extend Informatible

   has_one :coordinate, as: :info, inverse_of: :info, class_name: :CoordLink

   belongs_to :memory
   belongs_to :place, optional: true
   belongs_to :item, optional: true

   # synod : belongs_to
   # czin: has_one/many
   default_scope -> { order(:created_at) }

   accepts_nested_attributes_for :place
   accepts_nested_attributes_for :coordinate
   accepts_nested_attributes_for :item, reject_if: :all_blank

   validates :type, presence: true

   # serialization
   def happened_at= value
      value.is_a?(Array) && super(value.join('/')) || super
   end

   def happened_at
      value = read_attribute(:happened_at)
      value.to_s =~ /,/ && value.split(/,\*/) || value ;end;end
