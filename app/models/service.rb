class Service < ActiveRecord::Base
   extend Language

   belongs_to :info, polymorphic: true

   has_many :service_cantoes, dependent: :delete_all
   has_many :cantoes, through: :service_cantoes, dependent: :destroy
   has_many :chants, through: :service_cantoes, foreign_key: :canto_id, source: :canto, dependent: :destroy
   has_many :orisons, through: :service_cantoes, foreign_key: :canto_id, source: :canto, dependent: :destroy
   has_many :canticles, through: :service_cantoes, foreign_key: :canto_id, source: :canto, dependent: :destroy

#   has_alphabeth on: :name # TODO rollback

   accepts_nested_attributes_for :cantoes
   accepts_nested_attributes_for :chants
   accepts_nested_attributes_for :orisons
   accepts_nested_attributes_for :canticles

   validates :name, :language_code, :info, :info_type, presence: true ;end
