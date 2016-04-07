class Service < ActiveRecord::Base
   extend Language

   belongs_to :memory

   has_many :service_chants
   has_many :chants, through: :service_chants
   has_many :service_orisons
   has_many :orisons, through: :service_orisons
   has_many :service_canticles
   has_many :canticles, through: :service_canticles

   has_alphabeth on: :name

   accepts_nested_attributes_for :chants
   accepts_nested_attributes_for :orisons
   accepts_nested_attributes_for :canticles

   validates :name, :language_code, :memory_id, presence: true ;end
