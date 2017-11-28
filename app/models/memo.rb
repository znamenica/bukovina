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
   DAYS = %w(нд пн вт ср чт пт сб)
   DAYSR = DAYS.dup.reverse
   DAYSN = DAYS.dup.rotate

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

   before_save :fix_date

   def fix_date
      self.date =
      case self.date
      when /пасха/
         "+0"
      when /^дн\.(\d+)\.по пасхе/ #+24
         "+#{$1}"
      when /^дн\.(\d+)\.до пасхи/ #-24
         "-#{$1}"
      when /^(#{DAYS.join("|")})\.(\d+)\.по пасхе/ #+70
         daynum = DAYSN.index($1) + 1
         days = ($2.to_i - 1) * 7 + daynum
         "+#{days}"
      when /^(#{DAYS.join("|")})\.по пасхе/    #+7
         daynum = DAYSN.index($1) + 1
         "+#{daynum}"
      when /^(#{DAYS.join("|")})\.(\d+)\.до пасхи/  #-14
         daynum = DAYSR.index($1) + 1
         days = ($2.to_i - 1) * 7 + daynum
         "-#{days}"
      when /^(#{DAYS.join("|")})\.до пасхи/    #-7
         daynum = DAYSR.index($1) + 1
         "-#{daynum}"
      when /^дн\.(\d+)\.по (\d+\.\d+)$/   #29.06%7
         date = Time.parse("#{$2}.1970") + $1.to_i
         date.strftime("%1d.%m")
      when /^(#{DAYS.join("|")})\.близ (\d+\.\d+)$/   #29.06%7
         daynum = DAYS.index($1)
         date = Time.parse("#{$2}.1970") - 4.days
         "#{date.strftime("%1d.%m")}%#{daynum}"
      when /^(#{DAYS.join("|")})\.по (\d+\.\d+)$/   #29.06%7
         daynum = DAYS.index($1)
         date = Time.parse("#{$2}.1970")
         "#{date.strftime("%1d.%m")}%#{daynum}"
      when /^(#{DAYS.join("|")})\.до (\d+\.\d+)$/  #21.06%7
         daynum = DAYS.index($1)
         date = Time.parse("#{$2}.1970") - 8.days
         "#{date.strftime("%1d.%m")}%#{daynum}"
      when /^(#{DAYS.join("|")})\.(\d+)\.по (\d+\.\d+)$/   #29.06%7
         daynum = DAYS.index($1)
         date = Time.parse("#{$3}.1970") + ($2.to_i - 1) * 7
         "#{date.strftime("%1d.%m")}%#{daynum}"
      when /^(#{DAYS.join("|")})\.(\d+)\.до (\d+\.\d+)$/  #21.06%7
         daynum = DAYS.index($1)
         date = Time.parse("#{$3}.1970") - 8.days - ($2.to_i - 1) * 7
         "#{date.strftime("%1d.%m")}%#{daynum}"
      else
         self.date ;end;end

   def calendary_string= value
      self.calendary = Calendary.includes(:slug).where(slugs: { text: value }).first ;end;end
