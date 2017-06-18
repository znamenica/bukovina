class Canto < ActiveRecord::Base
   extend Language

   has_many :service_cantoes, inverse_of: :canto
   has_many :services, through: :service_cantoes
   has_many :canto_memories, inverse_of: :canto
   has_many :memories, through: :canto_memories
   has_many :targets, through: :canto_memories, foreign_key: :memory_id, source: :memory

   has_alphabeth on: %i(text prosomeion_title title)

   validates :type, presence: true

   def targets= value
      if value.kind_of?( Array )
         new_value = value.map do |v|
            if v.kind_of?(String) && v =~ /^\*(.*)/
               Memory.where(short_name: $1).first
            else
               v ;end;end
            .compact
         super(new_value)
      else
         super ;end;end;end
