class MemoryName < ActiveRecord::Base
   belongs_to :memory
   belongs_to :name

   enum state: [ :наречёное, :крещенское, :иноческое, :схимное ]
   enum feasibly: [ :false, :true ]

   validates_presence_of :memory_id, :name_id

   def to_s
      name.text ; end ; end
