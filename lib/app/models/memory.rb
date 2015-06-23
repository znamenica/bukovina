class Memory < ActiveRecord::Base
   has_and_belongs_to_many :names

   validates_presence_of :short_name
end
