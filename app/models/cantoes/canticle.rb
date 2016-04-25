class Canticle < Canto
   validates :tone, inclusion: { in: 1..8 }, if: ->{ tone.present? }
   validates :prosomeion_title, absence: true ;end
