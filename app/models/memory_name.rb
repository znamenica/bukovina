class MemoryName < ActiveRecord::Base
   belongs_to :memory
   belongs_to :name

   enum state: [ :наречёное, :самоданное, :крещенское, :чернецкое, :иноческое,
      :схимное, :отчество, :отчество_принятое, :кумство, :благословенное,
      :покаянное, :отечья, :мужнина, :наречёная, :самоданная, :матерня,
      :прозвание ]
   enum feasibly: [ :non_feasible, :feasible ]
   enum mode: [ :ored, :prefix ]

   validates_presence_of :memory_id, :name_id

   def to_s
      name.text ; end ; end
