# order[string]         - чин памяти
# council[string]       - соборы для памяти
# short_name[string]    - краткое имя
# covers_to_id[integer] - прокровительство
# quantity[string]      - количество
# bond_to_id[integer]   - отношение к (для икон это замысел или оригинал списка)
#
class Memory < ActiveRecord::Base
   extend DefaultKey
   extend Informatible

   has_default_key :short_name

   belongs_to :covers_to, class_name: :Place, optional: true
   belongs_to :bond_to, class_name: :Memory, optional: true

   has_many :memory_names, dependent: :destroy
   has_many :names, through: :memory_names
   has_many :paterics, as: :info, dependent: :destroy, class_name: :PatericLink
   has_many :events, dependent: :destroy
   has_many :memos, through: :events
   has_many :calendaries, -> { distinct }, through: :memos
   has_many :photo_links, as: :info, inverse_of: :info, class_name: :IconLink, dependent: :destroy # ЧИНЬ во photos
   has_one :slug, as: :sluggable, dependent: :destroy

   default_scope { left_outer_joins( :slug ).order( base_year: :asc, short_name: :asc, id: :asc ) }
   scope :icons, -> { where( order: :обр ) }
   scope :by_short_name, -> name { where( short_name: name ) }
   scope :in_calendaries, -> calendaries do
      left_outer_joins( :memos ).merge( Memo.in_calendaries( calendaries )).distinct ;end
   scope :with_date, -> (date, julian = false) do
      left_outer_joins( :memos ).merge( Memo.with_date( date, julian )).distinct ;end
   scope :with_token, -> text do
      left_outer_joins(:names, :descriptions).where( "short_name ~* ?", "\\m#{text}.*" ).or(
         where("descriptions.text ILIKE ? OR names.text ILIKE ?", "%#{text}%", "%#{text}%")).distinct ;end
   scope :with_tokens, -> token_list do
      # TODO fix the correctness of the query
      tokens = token_list.reject { |t| t =~ /\A[\s\+]*\z/ }
      cond = tokens.first[0] == '+' && 'TRUE' || 'FALSE'
      rel = left_outer_joins( :names, :descriptions, :memos ).where( cond )
      tokens.reduce(rel) do |rel, token|
         /\A(?<a>\+)?(?<text>.*)/ =~ token
         if a # AND operation
            rel.merge(Memory.with_token(text))
         else # OR operation
            rel.or(merge(Memory.with_token(text))) ;end;end
      .distinct ;end

   accepts_nested_attributes_for :memory_names, reject_if: :all_blank
   accepts_nested_attributes_for :paterics, reject_if: :all_blank
   accepts_nested_attributes_for :events, reject_if: :all_blank
   accepts_nested_attributes_for :memos, reject_if: :all_blank
   accepts_nested_attributes_for :photo_links, reject_if: :all_blank
   accepts_nested_attributes_for :covers_to, reject_if: :all_blank
   accepts_nested_attributes_for :slug, reject_if: :all_blank

   validates_presence_of :short_name, :events
   validates :base_year, format: { with: /\A-?\d+\z/ }
   validates :order, format: { with: /\A[ёа-я0-9]+\z/ }

   before_create :set_slug
   before_validation :set_base_year, on: :create

   def set_base_year
      types = %w(Resurrection Repose Writing Appearance Translation Sanctification)

      event = self.events.to_a.sort_by { |x| (types.index(x.type) || 100) }.first

      dates = event.happened_at.split(/[\/-]/)
      self.base_year ||=
      case dates.first
      when /([IVX]+)$/
         ($1.rom - 1) * 100 + 50
      when /\.\s*(\d+)$/
         $1
      when /(?:\A|\s|\()(\d+)$/
         $1
      when /(?:\A|\s|\(|\.)(\d+) до (?:нэ|РХ)/
         "-#{$1}"
      when /(:|сент)/
         dates.last.split(".").last
      when /давно/
         '-3760'
      else
         dates = event.happened_at.split(/[\/-]/)
         if /(?:\A|\s|\(|\.)(\d+) до (?:нэ|РХ)/ =~ dates.first
            "-#{$1}"
         else
            '0' ;end;end

   self.base_year ;end

   def self.by_slug slug
      unscoped.joins( :slug ).where( slugs: { text: slug } ).first ;end

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
