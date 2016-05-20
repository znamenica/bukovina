class Description < ActiveRecord::Base
   extend Language

   belongs_to :describable, polymorphic: true

   has_alphabeth on: :text

   validates :text, :language_code, :alphabeth_code, presence: true ; end
