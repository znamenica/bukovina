class Calendary < ActiveRecord::Base
   extend Language

   has_many :descriptions, proc { where( type: nil ) }, as: :describable, dependent: :delete_all
   has_many :names, as: :describable, dependent: :delete_all, class_name: :Appellation
   has_many :wikies, as: :info, dependent: :delete_all, class_name: :WikiLink
   has_many :links, as: :info, dependent: :delete_all, class_name: :BeingLink
   has_many :memos

   belongs_to :place, optional: true

   accepts_nested_attributes_for :descriptions, reject_if: :all_blank
   accepts_nested_attributes_for :names, reject_if: :all_blank
   accepts_nested_attributes_for :wikies, reject_if: :all_blank
   accepts_nested_attributes_for :links, reject_if: :all_blank
   accepts_nested_attributes_for :place, reject_if: :all_blank

   # has_alphabeth # TODO enable after import

   validates :slug, :names, presence: true # TODO add date after import
   validates :descriptions, :names, :wikies, :links, :place, associated: true ;end
