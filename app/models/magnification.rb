require_relative 'concern/language'

class Magnification < ActiveRecord::Base
   extend LanguageCode

   has_many :service_magnifications
   has_many :services, through: :service_magnifications

   has_language on: [ :text ]

   validates :text, presence: true ;end
