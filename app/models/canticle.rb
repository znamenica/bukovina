require_relative 'concern/language'

class Canticle < ActiveRecord::Base
   extend LanguageCode

   has_many :service_canticles
   has_many :services, through: :service_canticles

   has_language on: [ :text ]

   validates :tone, inclusion: { in: 1..8 }, if: ->{ tone.present? }
   validates :text, :type, presence: true ;end
