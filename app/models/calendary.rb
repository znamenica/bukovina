#licit[boolean]         - действительный календарь (не в разработке)
class Calendary < ActiveRecord::Base
   extend Language

   belongs_to :place, optional: true

   has_many :descriptions, proc { where( type: nil ) }, as: :describable, dependent: :delete_all
   has_many :names, as: :describable, dependent: :delete_all, class_name: :Appellation
   has_many :wikies, as: :info, dependent: :delete_all, class_name: :WikiLink
   has_many :links, as: :info, dependent: :delete_all, class_name: :BeingLink
   has_many :memos
   has_one :slug, as: :sluggable

   scope :licit, -> { where( licit: true ) }
   scope :by_slug, -> slug { joins( :slug ).where( slugs: { text: slug } ) }
   scope :named_as, -> name { joins( :names ).where( descriptions: { text: name } ) }
   scope :described_as, -> name { joins( :descriptions ).where( descriptions: { text: name } ) }

   accepts_nested_attributes_for :descriptions, reject_if: :all_blank
   accepts_nested_attributes_for :names, reject_if: :all_blank
   accepts_nested_attributes_for :wikies, reject_if: :all_blank
   accepts_nested_attributes_for :links, reject_if: :all_blank
   accepts_nested_attributes_for :place, reject_if: :all_blank
   accepts_nested_attributes_for :slug, reject_if: :all_blank

   # has_alphabeth # TODO enable after import
   # validates :language_code, inclusion: { in: Language.language_list }
   # validates :alphabeth_code, inclusion: { in: proc { |l|
   #   Language.alphabeth_list_for( l.language_code ) } }
   validates :slug, :names, presence: true # TODO add date after import
   validates :descriptions, :names, :wikies, :links, :place, associated: true
   
   def name_for language_codes
      names.where( language_code: language_codes ).first ;end;end
