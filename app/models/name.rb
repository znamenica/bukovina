class Name < ActiveRecord::Base
   extend Language

   has_many :memories, through: :memory_names
   has_many :memory_names
   belongs_to :similar_to, class_name: :Name

   has_alphabeth on: { text: [:nosyntax, allow: " ‑" ] }

   scope :with_token, -> text { where( "text ~* ?", "\\m#{text}.*" ) }

   validates :type, :text, :language_code, presence: true ;end
