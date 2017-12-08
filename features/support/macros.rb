module MacrosSupport
   ALPHABETH_MATHCES = {
      /румынск/ => :рм,
      /украинск/ => :ук,
      /сербск/ => :ср,
      /иверск/ => :ив,
      /английск/ => :ан,
      /греческ/ => :гр,
      /русск/ => :ру,
   }

   LANGUAGE_MATHCES = {
      /румынск/ => [:рм, :рм],
      /украинск/ => [:ук, :ук],
      /сербск/ => [:ср, :ср],
      /иверск/ => [:ив, :ив],
      /английск/ => [:re, :en]
   }

   LANGUAGES = { /русск(?:ая|ой|ое|ий|ого|ие|их)/     => :ру,
                 /греческ(?:ая|ой|ое|ий|ого|ие|их)/   => :гр }

   MODELS =  { /тропар[ья]/                        => Troparion,
               /величан(?:ий|ие|ия|ье)/            => Magnification,
               /песнопен(?:ий|ие|ия|ье)/           => Chant,
               /песм[уаы]?/                        => Canto,
               /спевн[уаы]?/                       => Canticle,
               /молени[йея]/                       => Orison,
               /кондака?/                          => Kontakion,
               /седал(?:ен|ьна) канона/            => Kanonion,
               /седал(?:ен|ьна) кафисмы/           => Kathismion,
               /седал(?:ен|ьна) полиелея/          => Polileosion,
               /возвашн[аы]/                       => CryStichira,
               /икоса?/                            => Ikos,
               /молитв[аы]/                        => Prayer,
               /богородич(?:ен|на)/                => Troparion,
               /им(?:я|ени)/                       => Name,
               /описан(?:ий|ие|ия|ье)/             => Description,
               /наименован(?:ий|ие|ия|ье)/         => Appellation,
               /событи[еяю]/                       => Event,
               /мест[оа]/                          => Place,
               /помин[аы]?/                        => Memo,
               /календар[ьяюи]/                    => Calendary,
               /ссылк[аиу]/                        => Link,
               /вики ссылк[аиу]/                   => WikiLink,
               /бытийн(?:ая|ой|ую) ссылк[аиу]/     => BeingLink,
               /иконн(?:ая|ой|ую) ссылк[аиу]/      => IconLink,
               /отечников(?:ая|ой|ую) ссылк[аиу]/  => PatericLink,
               /служебн(?:ая|ой|ую) ссылк[аиу]/    => ServiceLink,
               /памят[ьи]/                         => Memory,
               /памятно(?:е|го) им(?:я|ени)/       => MemoryName,
               /лично(?:е|го) им(?:я|ени)/         => Name,
               /отчеств[оа]/                       => Name,
               /фамили[ияю]/                       => Name,
               /предмета?/                         => Item,
               /тип[ау]? предмета/                 => ItemType,
               /слуга?/                            => Slug,
               /служебн(?:ые|ых) песм(?:ена)?/     => ServiceCanto,
               /служб[аыу]?/                       => Service }

   def language_code_for language_text
      LANGUAGE_MATHCES.any? {|(l, code)| break code if l =~ language_text  } ;end

   def alphabeth_code_for text
      ALPHABETH_MATHCES.any? {|(a, code)| break code if a =~ text  } ;end

   def sample &block
      if block_given?
         @sample_proc = block
      elsif @sample_result
         @sample_result
      elsif @sample_proc
         @sample_result = @sample_proc.call ;end ;end

   def subject &block
      if block_given?
         @subject_proc = block
      else
         @subject_result = @subject_proc.call ;end ;end

   def expand_attributes model, *args
      search_attrs = args.select { |x| x.is_a?(Hash) }.first
      model = model.is_a?(Symbol) && model.to_s.camelize.constantize || model
      new_attrs = {}

      search_attrs.to_a.each do |(attr, value)|
         if value.is_a?( String ) && /^\^(?<match_value>.*)/ =~ value
            /(?<base_attr>[^\.]+)(?:\.(?<relation>.*))?/ =~ attr
            /(?<attr>[^:]*)(?::(?<modelname>.*))?/ =~ base_attr
#            binding.pry
            submodel = ( modelname || base_attr.singularize ).camelize.constantize
            new_attrs[ "#{attr}_id" ] =
            if relation
               subattr = base_field( modelname || relation.singularize )
               submodel.joins( relation.to_sym ).where( relation => { subattr => match_value }).first.id
            else
               subattr = base_field( modelname || base_attr.singularize )
               submodel.where( subattr => match_value ).first.id ;end
            if model.new.respond_to?( "#{attr}_type" )
               new_attrs[ "#{attr}_type" ] = modelname.camelize ; end
         else
            value = value.is_a?( String ) && YAML.load( value ) || value
            new_attrs[ attr ] = value ; end ; end

      new_attrs ;end

   def create model, *args
      search_attrs = args.select { |x| x.is_a?(Hash) }.first
      attrs = args.select { |x| x.is_a?(Hash) }.last
      new_attrs = expand_attributes( model, search_attrs )

      if model.is_a?( Symbol )
         syms = args.select { |x| x.is_a?(Symbol) }
         object = FactoryGirl.build( model, *syms, new_attrs )
         object.save
         object
      else
         model.create( attrs.merge( new_attrs ) ) ;end ;end

   def find_or_create model, search_attrs, attrs = {}
      new_attrs = expand_attributes( model, search_attrs )

      # binding.pry
      model_class = model.is_a?(Symbol) && model.to_s.camelize.constantize || model
      model_class.where( new_attrs ).first || create( model, search_attrs, attrs ) ;end

   def get_type type_name
      types = { 'целый' => :integer, 'строка' => :string, 'текст' => :text }
      types[ type_name ] ; end

   def base_field name
      hash = { /memory|памят[ьи]/                     => :short_name,
               /magnification|величан(ий|ие|ия|ье)/   => :text,
               /service|служб[аыу]?/                  => :name,
               /name|им(я|ени)/                       => :text,
               /patronymic|отчеств[оа]/               => :text,
               /last_name|фамили[июя]/                => :text,
               /first_name|лично(е|го) им(я|ени)/     => :text,
               /chant|песнопен(ий|ие|ия|ье)/          => :text,
               /description|описан(ий|ие|ия|ье)/      => :text,
               /orison|молени[йея]/                   => :text,
               /event|событи[йея]/                    => :happened_at,
               /calendary|календар[ьяюи]/             => :slug,
               /slug|слуг[а]/                         => :text,
               /link|ссылк[аиу]/                      => :url }

      hash.reduce( nil ) { |s, (re, prop)| re =~ name && prop || s } ;end

   def relation_field name
      hash = { /description|описан(ий|ие|ия|ье)/      => 'describable' }

      hash.reduce( nil ) { |s, (re, prop)| re =~ name && prop || s } ;end

   def model_of name
      MODELS.reduce( nil ) { |s, (re, model)| re =~ name && model || s } ;end

   def relation_of name
      model_of( name ).to_s.tableize ;end

   def extract_key_to r, key
      similar_to = r.delete( key )
      if similar_to
         r[ key ] = Name.where( similar_to.deep_dup ).first ; end ; end


   def make_attrs_for hash, model
      joins = []
      add_attrs = nil

      attrs = hash.map do |(attr, value)|
         if /^\^(?<match_value>.*)$/ =~ value
            attrs = attr.to_s.split('.')

            new_attrs = attrs[0..-2].map( &:to_sym )
            joins.concat( new_attrs )
            model_name = model.to_s
            new_attrs = new_attrs.map do |a|
               model_name = model.reflections[ a.to_s ].class_name
               table = model_name.tableize
               [ a.to_s, table ]
               end
            .to_h.values

            (attr1, target_model_name) = attrs.last.split(":")
            /(?<real_attr>[^>]*)(?:>(?<relation>.*))?/ =~ attr1

            if not real_attr.empty?
               new_attrs << ( model_name.constantize.try( :default_key ) ||
                  "#{real_attr}_id" )

               target_model_name ||= real_attr.singularize
               model = target_model_name.camelize.constantize

               if /:/ =~ attrs.last
                  add_attrs = [ "#{real_attr}_type", model.to_s ] ;end
            else
               foreign_key = model.reflections[ relation ].foreign_key
               new_attrs = [ relation.tableize, foreign_key ]
               joins << relation.to_sym
               model = model_name.constantize ;end

            sample =
            if relation
               subattr = base_field( relation.singularize )
               # binding.pry
               model.joins( relation.to_sym ).where( relation.tableize => { subattr => match_value }).first
            else
               model.where( base_field( target_model_name ) => match_value ).first ;end

            new_value = /id$/ =~ new_attrs.last && sample.id ||
               sample.try( :default_key ) || sample

            [ new_attrs.join( '.' ), new_value ]
         else
            [ attr, value ] ;end;end
      .concat( [ add_attrs ] ).compact.to_h

      [ attrs, joins ] ;end

   def merge_array table, options = {}
      table.map do |e|
         [ options[ :merge ] ].compact.flatten.select{ |h| e[ h ] }.each do |h|
            e.merge!( e[ h ] )
            e.delete( h ) ; end
         e.map { |k, v| [ k, v.to_s ] }.to_h ; end ; end ; end

World(MacrosSupport)

def langs_re
   MacrosSupport::LANGUAGES.keys.join('|') ;end

def kinds_re
   MacrosSupport::MODELS.keys.join('|') ;end
