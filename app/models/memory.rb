class Memory < ActiveRecord::Base
   has_many :names, through: :memory_names
   has_many :memory_names
   has_many :descriptions

   validates_presence_of :short_name

   scope :by_short_name, ->(name) { where( short_name: name ) }

   def to_s
      memory_names.join( ' ' ) ; end ; end
