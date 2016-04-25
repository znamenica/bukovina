class Chant < Canticle
   extend ValidationCancel

   cancel_validates :prosomeion_title

   validates :tone, inclusion: { in: 1..8 }, if: ->{ tone.present? } ;end
