class Calendary < ActiveRecord::Base
   extend Language

   has_many :descriptions, proc { where( type: nil ) }, as: :describable, dependent: :destroy
   has_many :names, as: :describable, dependent: :destroy, class_name: :Appellation

   accepts_nested_attributes_for :descriptions, reject_if: :all_blank
   accepts_nested_attributes_for :names, reject_if: :all_blank

   has_alphabeth

   validates :slug, :date, presence: true

   validates :descriptions, :names, presence: true
   validates :descriptions, :names, associated: true ;end
