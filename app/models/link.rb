class Link < ActiveRecord::Base
   extend Language

   has_alphabeth novalidate: true

   validates :url, url: { no_local: true }
   validates :memory_id, :type, presence: true ; end
