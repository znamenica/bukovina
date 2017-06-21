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

   has_many :memory_names
   has_many :names, through: :memory_names
   has_many :paterics, class_name: :PatericLink, foreign_key: :info_id
   has_many :events
   has_many :memos
   has_many :photo_links, foreign_key: :info_id, inverse_of: :info, class_name: :IconLink # ЧИНЬ во photos
   has_one :slug, as: :sluggable

   belongs_to :covers_to, class_name: :Place, optional: true
   belongs_to :sight, class_name: :Memory, optional: true

   default_scope { includes( :slug ).where.not( slugs: { text: nil } ) }

   scope :by_short_name, -> name { where( short_name: name ) }
   scope :by_slug, -> slug { includes( :slug ).where( slugs: { text: slug } ) }
   scope :by_date, -> date { includes( :memoes ).where( memo: { date: date } ) }
   scope :by_text, -> text do
      includes( :names, :description ).where( names: text ).
                                    or.where( description: { text: text } ) ;end

   accepts_nested_attributes_for :memory_names, reject_if: :all_blank
   accepts_nested_attributes_for :paterics, reject_if: :all_blank
   accepts_nested_attributes_for :events, reject_if: :all_blank
   accepts_nested_attributes_for :memos, reject_if: :all_blank
   accepts_nested_attributes_for :photo_links, reject_if: :all_blank
   accepts_nested_attributes_for :covers_to, reject_if: :all_blank
   accepts_nested_attributes_for :slug, reject_if: :all_blank

   validates_presence_of :short_name, :events

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

   def kontakions text_present = true
      relation = Kontakion.joins( :services ).where( services: { id: services.pluck( :id ) } )
      text_present && relation.where.not( { text: nil } ) || relation ;end

   def to_s
      memory_names.join( ' ' ) ; end ; end
