class MemoryName < ActiveRecord::Base
   belongs_to :memory
   belongs_to :name

   enum state: [ :наречёное, :крещенское, :чернецкое, :иноческое, :схимное,
      :отчество ]
   enum feasibly: [ :non_feasible, :feasible ]
   enum mode: [ :ored, :prefix ]

   validates_presence_of :memory_id, :name_id

   def to_s
      name.text ; end ; end
