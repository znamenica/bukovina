class Link < ActiveRecord::Base
   extend LanguageCode

   has_language novalidate: true

   validates :url, url: { no_local: true }
   validates :memory_id, :type, presence: true ; end
