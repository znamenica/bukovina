class Canto < ActiveRecord::Base
   extend Language

   has_many :service_cantoes, inverse_of: :canto
   has_many :services, through: :service_cantoes
   has_many :canto_memories, inverse_of: :canto
   has_many :targets, through: :canto_memories, foreign_key: :memory_id

   has_alphabeth on: [ :text, :prosomeion_title, :title ]

   validates :type, :text, presence: true ;end
