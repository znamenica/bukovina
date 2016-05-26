class Service < ActiveRecord::Base
   extend Language

   belongs_to :info, polymorphic: true

   has_many :service_cantoes
   has_many :cantoes, through: :service_cantoes
   has_many :chants, through: :service_cantoes, foreign_key: :canto_id, source: :canto
   has_many :orisons, through: :service_cantoes, foreign_key: :canto_id, source: :canto
   has_many :canticles, through: :service_cantoes, foreign_key: :canto_id, source: :canto

#   has_alphabeth on: :name # rollback

   accepts_nested_attributes_for :cantoes
   accepts_nested_attributes_for :chants
   accepts_nested_attributes_for :orisons
   accepts_nested_attributes_for :canticles

   validates :name, :language_code, presence: true ;end
