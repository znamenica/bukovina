class Calendary < ActiveRecord::Base
   extend Language

   has_many :descriptions, as: :describable, dependent: :destroy
   has_many :names, as: :describable, dependent: :destroy, class_name: :Description

   accepts_nested_attributes_for :descriptions, reject_if: :all_blank
   accepts_nested_attributes_for :names, reject_if: :all_blank

   # TODO add validation to at least one description and name
   has_alphabeth

   validates :slug, :date, presence: true

   validates :descriptions, :names, associated: true ; end
