module Informatible
   extend ActiveSupport::Concern

   def self.extended base
      base.has_many :descriptions, as: :describable
      base.has_many :wikies, class_name: :WikiLink, foreign_key: :info_id
      base.has_many :beings, class_name: :BeingLink, foreign_key: :info_id
      base.has_many :icon_links, foreign_key: :info_id # ЧИНЬ во icons
      base.has_many :service_links, foreign_key: :info_id #ЧИНЬ превод во services
      base.has_many :services, foreign_key: :info_id

      base.accepts_nested_attributes_for :descriptions, reject_if: :all_blank
      base.accepts_nested_attributes_for :wikies, reject_if: :all_blank
      base.accepts_nested_attributes_for :beings, reject_if: :all_blank
      base.accepts_nested_attributes_for :icon_links, reject_if: :all_blank
      base.accepts_nested_attributes_for :service_links, reject_if: :all_blank
      base.accepts_nested_attributes_for :services, reject_if: :all_blank ;end ;end
