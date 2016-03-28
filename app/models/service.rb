require_relative 'concern/language'

class Service < ActiveRecord::Base
   extend LanguageCode

   belongs_to :memory

   has_many :service_chants
   has_many :chants, through: :service_chants

   has_language on: :name

   accepts_nested_attributes_for :chants

   validates :name, :language_code, :memory_id, presence: true ;end
