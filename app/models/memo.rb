require 'when_easter'

# happened_at[string]   - дата добавления записи в календарь
# date[string]          - дата в году постоянная или перемещаемая, когда память отмечается
# before[int]           - дней предпразднества
# after[int]            - дней попразднества
# inevening[int]        - дней навечерий
# memory_id[int]        - ссылка на память
# calendary_id[int]     - ссылка на календарь
#
class Memo < ActiveRecord::Base
   belongs_to :memory
   belongs_to :calendary

   has_many :event_memos
   has_many :events, through: :event_memos
   has_many :service_links, as: :info, inverse_of: :info #ЧИНЬ превод во services
   has_many :services, as: :info, inverse_of: :info

   scope :in_calendaries, -> calendaries do
      # TODO make single embedded select or after fix rails bug use merge
      calendary_ids = Slug.where( text: calendaries, sluggable_type: 'Calendary' ).pluck( :sluggable_id )
      where( calendary_id: calendary_ids ) ;end

   scope :with_date, -> (date_str, julian = false) do
      date = Date.parse(date_str)
      new_date = date.strftime("%1d.%m")
      wday = (date + (julian && 13.days || 0)).wday
      relays = (1..7).map { |x| (date - x.days).strftime("%1d.%m") + "%#{wday}" }
      easter = WhenEaster::EasterCalendar.find_greek_easter_date(date.year)
      days = sprintf( "%+i", date.to_time.yday - easter.yday )
      where( date: relays.dup << new_date << days ) ;end

   accepts_nested_attributes_for :event_memos, reject_if: :all_blank
   accepts_nested_attributes_for :service_links, reject_if: :all_blank
   accepts_nested_attributes_for :services, reject_if: :all_blank

   validates :memory, presence: true

   def calendary_string= value
      self.calendary = Calendary.includes(:slug).where(slugs: { text: value }).first ;end;end
