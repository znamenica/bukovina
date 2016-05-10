class Link < ActiveRecord::Base
   extend Language

   has_alphabeth novalidate: true

   validates :url, url: { no_local: true }
   validates :info_id, :info_type, :type, presence: true ; end
