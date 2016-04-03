require_relative 'concern/language'

class Orison < ActiveRecord::Base
   extend LanguageCode

   has_many :service_orisons
   has_many :services, through: :service_orisons

   has_language on: [ :text ]

   validates :text, :type, presence: true ;end
