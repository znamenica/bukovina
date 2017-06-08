# order[string]      - чин памяти
# council[string]    - соборы для памяти
# short_name[string] - краткое имя
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

   scope :by_short_name, ->(name) { where( short_name: name ) }

   accepts_nested_attributes_for :memory_names, reject_if: :all_blank
   accepts_nested_attributes_for :paterics, reject_if: :all_blank
   accepts_nested_attributes_for :events, reject_if: :all_blank
   accepts_nested_attributes_for :memos, reject_if: :all_blank

   validates_presence_of :short_name, :events

   def to_s
      memory_names.join( ' ' ) ; end ; end
