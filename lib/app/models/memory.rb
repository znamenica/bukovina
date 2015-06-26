class Memory < ActiveRecord::Base
   has_many :names, through: :memory_names
   has_many :memory_names

   validates_presence_of :short_name
end
