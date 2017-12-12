require 'when_easter'

# add_date[string]      - дата добавления записи в календарь
# year_date[string]     - дата в году постоянная или перемещаемая, когда память отмечается
# event_id[int]         - ссылка на событие
# calendary_id[int]     - ссылка на календарь
#
class Memo < ActiveRecord::Base
   DAYS = %w(нд пн вт ср чт пт сб)
   DAYSR = DAYS.dup.reverse
   DAYSN = DAYS.dup.rotate

   belongs_to :calendary
   belongs_to :event
   belongs_to :bond_to, class_name: :Memo

   has_many :service_links, as: :info, inverse_of: :info #ЧИНЬ превод во services
   has_many :services, as: :info, inverse_of: :info
   has_many :descriptions, proc { where( type: nil ) }, as: :describable, dependent: :delete_all
   has_many :links, as: :info, dependent: :delete_all, class_name: :BeingLink

   delegate :memory, to: :event

   #enum bind_kind: [ 'несвязаный', 'навечерие', 'предпразднество', 'попразднество' ]

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

   scope :with_token, -> text do
      #SELECT  DISTINCT  "memoes".* FROM "memoes","events","descriptions","calendaries" WHERE (("descriptions"."describable_id" = "memoes"."id" AND "descriptions"."describable_type" = 'Memo') OR ("memoes"."calendary_id" = "descriptions"."describable_id" AND "descriptions"."describable_type" = 'Calendary') OR ("memoes"."event_id" = "events"."id" AND "events"."memory_id" = "descriptions"."describable_id" AND "descriptions"."describable_type" = 'Memory')) AND descriptions.text ILIKE '%Азарьин%'; TODO + names
      #
#                                      merge(Calendary.with_token(text)).or(
#            left_outer_joins(:memory).merge(Memory.with_token(text)))))) ;end
      left_outer_joins(:descriptions).where("descriptions.text ILIKE ?", "%#{text}%").or(
                                      where("memoes.add_date ILIKE ?", "%#{text}%").or(
                                      where("memoes.year_date ILIKE ?", "%#{text}%"))) ;end

   scope :with_tokens, -> token_list do
      # TODO fix the correctness of the query
      tokens = token_list.reject { |t| t =~ /\A[\s\+]*\z/ }
      cond = tokens.first[0] == '+' && 'TRUE' || 'FALSE'
      rel = left_outer_joins(:descriptions).where( cond )
      tokens.reduce(rel) do |rel, token|
         /\A(?<a>\+)?(?<text>.*)/ =~ token
         if a # AND operation
            rel.with_token(text)
         else # OR operation
            rel.or(self.with_token(text)) ;end;end
      .distinct ;end

   scope :with_event_id, -> (event_id) do
      where(event_id: event_id) ;end

   scope :with_calendary_id, -> (calendary_id) do
      where(calendary_id: calendary_id) ;end

   accepts_nested_attributes_for :service_links, reject_if: :all_blank
   accepts_nested_attributes_for :services, reject_if: :all_blank
   accepts_nested_attributes_for :descriptions, reject_if: :all_blank, allow_destroy: true
   accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

   validates :calendary, :event, :year_date, presence: true

   before_validation :fix_year_date
   before_create -> { self.bind_kind ||= 'несвязаный' }

   def fix_year_date
      self.year_date =
      case self.year_date
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
         self.year_date ;end;end

   def calendary_string= value
      self.calendary = Calendary.includes(:slug).where(slugs: { text: value }).first ;end;end
