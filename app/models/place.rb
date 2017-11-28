class Place < ActiveRecord::Base
   has_many :descriptions, as: :describable
   has_many :events

   scope :with_token, -> text { joins(:descriptions).where( "descriptions.text ~* ?", "\\m#{text}.*" ) }

   accepts_nested_attributes_for :descriptions

   validates :descriptions, presence: true
   validates :descriptions, associated: true

   def description_for language_code
      descriptions.where(language_code: language_code).first ;end;end
