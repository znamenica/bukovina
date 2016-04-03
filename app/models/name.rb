class Name < ActiveRecord::Base
   extend LanguageCode

   has_many :memories, through: :memory_names
   has_many :memory_names
   belongs_to :similar_to, class_name: :Name

   has_language on: { text: [:nosyntax, allow: " ‑" ] }

   validates :type, :text, :language_code, presence: true ;end
