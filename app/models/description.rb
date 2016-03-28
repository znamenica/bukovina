class Description < ActiveRecord::Base
   extend LanguageCode

   belongs_to :describable, polymorphic: true

   has_language on: :text

   validates :text, :language_code, presence: true ; end
