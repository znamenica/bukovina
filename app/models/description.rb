class Description < ActiveRecord::Base
   extend Language

   belongs_to :describable, polymorphic: true

   has_alphabeth on: :text

   validates :text, :language_code, presence: true ; end
