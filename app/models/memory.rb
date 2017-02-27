class Memory < ActiveRecord::Base
   extend DefaultKey
   extend Informatible

   has_default_key :short_name

   has_many :memory_names
   has_many :names, through: :memory_names
   has_many :paterics, class_name: :PatericLink, foreign_key: :info_id

   validates_presence_of :short_name

   scope :by_short_name, ->(name) { where( short_name: name ) }

   def to_s
      memory_names.join( ' ' ) ; end ; end
