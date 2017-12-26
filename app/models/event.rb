# type[string]   наименование класса события
# memory_id[int] id памяти, событие которой произошло
# place_id[int]  id места, где произошло событие
# item_id[int]   id предмета, к которому применяется событие
class Event < ActiveRecord::Base
   extend Informatible

   USUAL = [
      'Marriage',
      'Exaltation',
      'Ascension',
      'Restoration',
      'Resurrection',
      'Entrance',
      'Conception',
      'Protection',
      'Conceiving',
      'Writing',
      'Sanctification',
      'Uncovering',
      'Circumcision',
      'Revival',
      'Renunciation',
      'Placing',
      'Translation',
      'Adoration',
      'Transfiguration',
      'Repose',
      'Nativity',
      'Council',
      'Meeting',
      'Passion',
      'Supper',
      'Assurance',
      'Miracle',
      'Appearance',
   ]

   has_many :memos, dependent: :delete_all
   has_one :coordinate, as: :info, inverse_of: :info, class_name: :CoordLink
   has_many :kinds, foreign_key: :kind, primary_key: :type, class_name: :EventKind

   belongs_to :memory
   belongs_to :place, optional: true
   belongs_to :item, optional: true

   # synod : belongs_to
   # czin: has_one/many
   default_scope -> { order(:created_at) }

   scope :usual, -> { where(type: USUAL) }
   scope :with_token, -> text do
      where("type ILIKE ?", "%#{text}%").or(where(type_number: text.to_i)) ;end
   scope :with_memory_id, -> memory_id do
      where(memory_id: memory_id) ;end

   accepts_nested_attributes_for :place
   accepts_nested_attributes_for :coordinate
   accepts_nested_attributes_for :item, reject_if: :all_blank

   validates_presence_of :kinds, :type

   def kind_for language_code
      kinds.where(language_code: language_code).first ;end

   def description_for language_code
      descriptions.where(language_code: language_code).first ;end

   def troparions text_present = true
      relation = Troparion.joins( :services ).where( services: { id: services.pluck( :id ) } )
      text_present && relation.where.not( { text: nil } ) || relation ;end

   def troparions_for language_code, text_present = true
      troparions( text_present ).where(language_code: language_code) ;end

   def kontakions text_present = true
      relation = Kontakion.joins( :services ).where( services: { id: services.pluck( :id ) } )
      text_present && relation.where.not( { text: nil } ) || relation ;end

   def kontakions_for language_code, text_present = true
      kontakions( text_present ).where(language_code: language_code) ;end

   # serialization
   def happened_at= value
      value.is_a?(Array) && super(value.join('/')) || super
   end

   def happened_at
      value = read_attribute(:happened_at)
      value.to_s =~ /,/ && value.split(/,\*/) || value ;end;end
