class Memory < ActiveRecord::Base
   has_many :names, through: :memory_names
   has_many :memory_names
   has_many :descriptions, as: :describable
   has_many :wikies, class_name: :WikiLink
   has_many :beings, class_name: :BeingLink
   has_many :paterics, class_name: :PatericLink
   has_many :icon_links # во icons
   has_many :service_links #ЧИНИ перевести в services

   validates_presence_of :short_name

   scope :by_short_name, ->(name) { where( short_name: name ) }

   def to_s
      memory_names.join( ' ' ) ; end ; end
