class Chant < Canticle
   extend ValidationCancel

   cancels_validation :prosomeion_title

   validates :tone, inclusion: { in: 1..8 }, if: ->{ tone.present? } ;end
