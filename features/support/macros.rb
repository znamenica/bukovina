module MacrosSupport
   LANGUAGE_MATHCES = {
      /румынск/ => [:рм, :рм],
      /украинск/ => [:ук, :ук],
      /сербск/ => [:ср, :ср],
      /иверск/ => [:ив, :ив],
      /английск/ => [:re, :en]
   }

   SUBATTRS = [ :short_name, :text, :url ]

   LANGUAGES = { /русск(?:ая|ой|ое|ий|ого|ие|их)/     => :ру,
                 /греческ(?:ая|ой|ое|ий|ого|ие|их)/   => :гр }

   MODELS =  { /тропар[ья]/                        => Troparion,
               /величан(?:ий|ие|ия|ье)/            => Magnification,
               /песнопен(?:ий|ие|ия|ье)/           => Chant,
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
               /ссылк[аиу]/                        => Link,
               /вики ссылк[аиу]/                   => WikiLink,
               /бытийн(?:ая|ой|ую) ссылк[аиу]/     => BeingLink,
               /иконн(?:ая|ой|ую) ссылк[аиу]/      => IconLink,
               /отечников(?:ая|ой|ую) ссылк[аиу]/  => PatericLink,
               /служебн(?:ая|ой|ую) ссылк[аиу]/    => ServiceLink,
               /памят[ьи]/                         => Memory,
               /памятно(?:е|го) им(?:я|ени)/       => MemoryName,
               /лично(?:е|го) им(?:я|ени)/         => FirstName,
               /отчеств[оа]/                       => Patronymic,
               /фамили[ияю]/                       => LastName,
               /служб[аыу]?/                       => Service }

   def language_code_for( language_text )
      LANGUAGE_MATHCES.any? {|(l, code)| break code if l =~ language_text  } ;end

   def sample &block
      if block_given?
         @sample_proc = block
      elsif @sample_proc
         @sample_proc.call ;end ;end

   def subject &block
      if block_given?
         @subject_proc = block
      else
         @subject_result = @subject_proc.call ;end ;end

   def expand_attributes model, search_attrs
      new_attrs = {}
      search_attrs.to_a.each do |(attr, value)|
         if value.is_a?( String ) && /^\*(?<match_value>.*)/ =~ value
            /(?<attr>[^:]*)(?::(?<modelname>.*))?/ =~ attr
            submodel = ( modelname || attr ).camelize.constantize
            subattr = SUBATTRS.select { |a| submodel.new.respond_to?( a ) }.first
            new_attrs[ :"#{attr}_id" ] =
            submodel.where( subattr => match_value ).first.id
            if model.new.respond_to?( "#{attr}_type" )
               new_attrs[ :"#{attr}_type" ] = modelname.camelize ; end
         else
            value = value.is_a?( String ) && YAML.load( value ) || value
            new_attrs[ attr ] = value ; end ; end

      new_attrs ;end

   def create model, search_attrs = {}, attrs = {}
      if model.is_a?( Symbol )
         object = FactoryGirl.build( model, search_attrs )
         object.save
         object
      else
         new_attrs = expand_attributes( model, search_attrs )

         model.create( attrs.merge( new_attrs ) ) ;end ;end

   def find_or_create model, search_attrs, attrs = {}
      new_attrs = expand_attributes( model, search_attrs )

      model.where( new_attrs ).first_or_create(
         attrs.merge( new_attrs ) ) ; end

   def get_type type_name
      { 'целый' => :integer, 'строка' => :string }[ type_name ] ; end

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
               /link|ссылк[аиу]/                      => :url }

      hash.reduce( nil ) { |s, (re, prop)| re =~ name && prop || s } ;end

   def model_of name
      MODELS.reduce( nil ) { |s, (re, model)| re =~ name && model || s } ;end

   def extract_key_to r, key
      similar_to = r.delete( key )
      if similar_to
         r[ key ] = Name.where( similar_to.deep_dup ).first ; end ; end

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
