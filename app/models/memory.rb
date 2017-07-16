# order[string]         - чин памяти
# council[string]       - соборы для памяти
# short_name[string]    - краткое имя
# covers_to_id[integer] - прокровительство
# quantity[string]      - количество
# sight_id[integer]     - вид
# view_string[string]   - строка памяти как надвид памяти (преложить в вид)
#
class Memory < ActiveRecord::Base
   extend DefaultKey
   extend Informatible

   has_default_key :short_name

   belongs_to :covers_to, class_name: :Place, optional: true
   belongs_to :sight, class_name: :Memory, optional: true

   has_many :memory_names, dependent: :destroy
   has_many :names, through: :memory_names
   has_many :paterics, as: :info, dependent: :destroy, class_name: :PatericLink
   has_many :events, dependent: :destroy
   has_many :memos, dependent: :destroy
   has_many :photo_links, as: :info, inverse_of: :info, class_name: :IconLink, dependent: :destroy # ЧИНЬ во photos
   has_one :slug, as: :sluggable

   # default_scope { includes( :slug ).where.not( slugs: { text: nil } ) }
   default_scope { includes(:slug) }
   scope :by_short_name, -> name { where( short_name: name ) }
   scope :by_slug, -> slug { joins( :slug ).where( slugs: { text: slug } ) }
   scope :for_calendaries, -> calendaries do
      joins( :memos ).merge( Memo.for_calendaries( calendaries )).distinct ;end
   scope :with_date, -> date do
      joins( :memos ).merge( Memo.with_date( date )).distinct ;end
   scope :with_text, -> text do
      joins( :names, :descriptions )
     .where("names.text ILIKE ? OR descriptions.text ILIKE ?", "%#{text}%", "%#{text}%")
     .distinct ;end

   accepts_nested_attributes_for :memory_names, reject_if: :all_blank
   accepts_nested_attributes_for :paterics, reject_if: :all_blank
   accepts_nested_attributes_for :events, reject_if: :all_blank
   accepts_nested_attributes_for :memos, reject_if: :all_blank
   accepts_nested_attributes_for :photo_links, reject_if: :all_blank
   accepts_nested_attributes_for :covers_to, reject_if: :all_blank
   accepts_nested_attributes_for :slug, reject_if: :all_blank

   validates_presence_of :short_name, :events

   before_create :set_slug

   def description_for language_code
      descriptions.where(language_code: language_code).first ;end

   def beings_for language_code
      abeings = beings.where(language_code: language_code)
      abeings.present? && abeings || nil ;end

   def wikies_for language_code
      awikies = wikies.where(language_code: language_code)
      awikies.present? && awikies || nil ;end

   def paterics_for language_code
      apaterics = paterics.where(language_code: language_code)
      apaterics.present? && apaterics || nil ;end

   def valid_icon_links
      # TODO cleanup when filter for jpg/png etc will be added to model
      icon_links.where("url ~ '.(jpg|png)$'") ;end

   def filtered_events
      types = %w(Repose Appearance Miracle Writing Founding Canonization)
      events.where(type: types) ;end

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

   def set_slug
      self.slug = Slug.new(base: self.short_name) if self.slug.blank? ;end

   def to_s
      memory_names.join( ' ' ) ; end ; end
