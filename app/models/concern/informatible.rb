module Informatible
   extend ActiveSupport::Concern

   def self.extended base
      base.has_many :descriptions, -> { where(type: nil) }, as: :describable, dependent: :destroy
      base.has_many :wikies, as: :info, class_name: :WikiLink, dependent: :destroy
      base.has_many :beings, as: :info, class_name: :BeingLink, dependent: :destroy
      base.has_many :icon_links, as: :info, foreign_key: :info_id, inverse_of: :info, dependent: :destroy # ЧИНЬ во icons
      base.has_many :service_links, as: :info, inverse_of: :info, dependent: :destroy #ЧИНЬ превод во services
      base.has_many :services, as: :info, inverse_of: :info, dependent: :destroy

      base.accepts_nested_attributes_for :descriptions, reject_if: :all_blank
      base.accepts_nested_attributes_for :wikies, reject_if: :all_blank
      base.accepts_nested_attributes_for :beings, reject_if: :all_blank
      base.accepts_nested_attributes_for :icon_links, reject_if: :all_blank
      base.accepts_nested_attributes_for :service_links, reject_if: :all_blank
      base.accepts_nested_attributes_for :services, reject_if: :all_blank ;end ;end
