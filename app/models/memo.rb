# happened_at[string]   - дата добавления записи в календарь
# date[string]          - дата в году постоянная или перемещаемая, когда память отмечается
# before[int]           - дней предпразднества
# after[int]            - дней попразднества
# inevening[int]        - дней навечерий
# memory_id[int]        - ссылка на память
# calendary_id[int]     - ссылка на календарь
#
class Memo < ActiveRecord::Base
   has_many :event_memos
   has_many :events, through: :event_memos
   has_many :service_links, foreign_key: :info_id, inverse_of: :info #ЧИНЬ превод во services
   has_many :services, foreign_key: :info_id, inverse_of: :info

   belongs_to :memory
   belongs_to :calendary

   accepts_nested_attributes_for :event_memos, reject_if: :all_blank
   accepts_nested_attributes_for :service_links, reject_if: :all_blank
   accepts_nested_attributes_for :services, reject_if: :all_blank

   validates :memory, presence: true

   def calendary_string= value
      self.calendary = Calendary.where(slug: value).first ;end;end
