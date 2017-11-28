class ItemType < ActiveRecord::Base
   has_many :items
   has_many :descriptions, as: :describable

   scope :with_token, -> text { joins(:descriptions).where( "descriptions.text ~* ?", "\\m#{text}.*" ) }
   scope :descriptions_for, -> language_code { joins(:descriptions).where(descriptions: { language_code: language_code }) }

   accepts_nested_attributes_for :descriptions

   validates :descriptions, presence: true
   validates :descriptions, associated: true

   def description_for language_code
      descriptions.where(language_code: language_code).first ;end;end
