# order[string]         - чин памяти
# council[string]       - соборы для памяти
# short_name[string]    - краткое имя
# covers_to_id[integer] - прокровительство
# short[string]         - крат
# quantity[string]      - количество
# sight_id[integer]     - вид
# view_string[string]   - строка памяти как надвид памяти (преложить в вид)
#
class Memory < ActiveRecord::Base
   extend DefaultKey
   extend Informatible

   has_default_key :short_name

   has_many :memory_names
   has_many :names, through: :memory_names
   has_many :paterics, class_name: :PatericLink, foreign_key: :info_id
   has_many :events
   has_many :memos
   has_many :photo_links, foreign_key: :info_id, inverse_of: :info, class_name: :IconLink # ЧИНЬ во photos

   belongs_to :covers_to, class_name: :Place, optional: true
   belongs_to :sight, class_name: :Memory, optional: true

   scope :by_short_name, ->(name) { where( short_name: name ) }

   accepts_nested_attributes_for :memory_names, reject_if: :all_blank
   accepts_nested_attributes_for :paterics, reject_if: :all_blank
   accepts_nested_attributes_for :events, reject_if: :all_blank
   accepts_nested_attributes_for :memos, reject_if: :all_blank
   accepts_nested_attributes_for :photo_links, reject_if: :all_blank
   accepts_nested_attributes_for :covers_to, reject_if: :all_blank

   validates_presence_of :short_name, :events

   def to_s
      memory_names.join( ' ' ) ; end ; end
