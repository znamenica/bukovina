class Memory < ActiveRecord::Base
   extend DefaultKey

   has_default_key :short_name

   has_many :names, through: :memory_names
   has_many :memory_names
   has_many :descriptions, as: :describable
   has_many :wikies, class_name: :WikiLink
   has_many :beings, class_name: :BeingLink
   has_many :paterics, class_name: :PatericLink
   has_many :icon_links # ЧИНЬ во icons
   has_many :service_links #ЧИНЬ превод во services
   has_many :services

   validates_presence_of :short_name

   scope :by_short_name, ->(name) { where( short_name: name ) }

   def to_s
      memory_names.join( ' ' ) ; end ; end
