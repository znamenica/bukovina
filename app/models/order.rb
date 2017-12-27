class Order < ActiveRecord::Base
   extend Language

   has_many :memories, foreign_key: :order, primary_key: :order
   
   has_alphabeth on: {
      text: [ :nosyntax, allow: " ‑" ],
      note: [],
      short_note: [], }

   validates :order, :note, :short_note, :text, :language_code, presence: true ;end
