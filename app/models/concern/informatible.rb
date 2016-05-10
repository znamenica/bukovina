module Informatible
   extend ActiveSupport::Concern

   included do
      has_many :descriptions, as: :describable
      has_many :wikies, class_name: :WikiLink, foreign_key: :info_id
      has_many :beings, class_name: :BeingLink, foreign_key: :info_id
      has_many :icon_links, foreign_key: :info_id # ЧИНЬ во icons
      has_many :service_links, foreign_key: :info_id #ЧИНЬ превод во services
      has_many :services, foreign_key: :info_id ;end ;end
