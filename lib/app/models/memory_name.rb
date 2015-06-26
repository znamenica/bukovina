class MemoryName < ActiveRecord::Base
   belongs_to :memory
   belongs_to :name

   enum state: [ :наречёное, :крещенское, :иноческое, :схимное ]

   validates_presence_of :memory_id, :name_id

   enum feasibly: [ :false, :true ]
end
