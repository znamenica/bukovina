require_relative 'concern/language'

class Chant < ActiveRecord::Base
   extend LanguageCode

   has_many :service_chants
   has_many :services, through: :service_chants

   has_language on: [ :text, :prosomeion_title ]

   validates :tone, inclusion: { in: 1..8 }, if: ->{ tone.present? }
   validates :type, :text, presence: true ;end
