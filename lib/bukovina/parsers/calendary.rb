class Bukovina::Parsers::Calendary
   attr_reader :errors, :target

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   SUBPARSERS = {
      'год' => :year,
      'крат' => :calendary,
      'ссылка' => :link,
      'описание' => :desc,
      'автор' => :author,
      'имя' => :name,
      'название' => :name,
      'место' => :place,
      'вики' => :wiki,
      'собор' => :council,
   }

   CALENDARIES = %w(916
                    азар
                    ассе
                    афин
                    библ
                    библ
                    блап
                    блр
                    болл
                    бпм
                    валл
                    взр1
                    взр2
                    влат
                    влбр
                    влдв
                    влчм
                    впдв
                    врнж
                    вскс
                    всрб
                    всс
                    вчм
                    гбмч
                    гдк
                    герм
                    гмин
                    гпм
                    груз
                    греч
                    грм
                    грот
                    грхэ
                    гскс
                    джрд
                    длг
                    дмрт
                    дни
                    днсс
                    дрге
                    дргм
                    евг
                    евер
                    ждр
                    змин
                    иерн
                    иерн
                    иерс
                    имм
                    ипдл
                    ит
                    к688
                    каро
                    карф
                    кирл
                    киж
                    лавр
                    лавс
                    лион
                    луг
                    мвс
                    меа
                    мокс
                    мсн
                    нкс
                    нмр
                    нмрл
                    нмчк
                    новг
                    нсп2
                    нспр
                    остр
                    охап
                    охр
                    парж
                    парс
                    плнд
                    пол
                    пслт
                    пспр
                    птпр
                    птрг
                    путя
                    ре12
                    рм
                    росс
                    рпт
                    рпц
                    рпца
                    рсап
                    рсм
                    рум
                    румо
                    русз
                    серб
                    синс
                    сир
                    сирм
                    скал
                    скмр
                    сксд
                    скср
                    скц
                    слжб
                    служ
                    спр
                    спсс
                    сптр
                    спц
                    ссм
                    стип
                    стсл
                    студ
                    супр
                    сурж
                    суст
                    твц
                    тырн
                    уцс
                    укр
                    фип
                    флпс
                    флпс
                    хлуд
                    хрис
                    чсл
                    элл)

   COUNSILS = %w(рус русз)

   def parse events, options = {}
      # TODO skip return if errors found
      #
      @target = options[:target]

      res =
      case events
      when Hash
         event = parse_hash( events )

         [ event ]
      when Array
         if events.blank?
            @errors << Parsers::BukovinaInvalidValueError.new( "Value of event " +
               "array is empty" ) ;end

         event_list = events.map do |event|
            parse_hash( event )
         end.compact

         event_list
      when NilClass
         @errors << Parsers::BukovinaInvalidValueError.new( "Event list" +
            "can't be blank" )
      else
         raise Parsers::BukovinaInvalidClass, "Invalid class #{name.class} " +
            "for Name line '#{name}'" ; end

      @errors.empty? && res || nil

   rescue Parsers::BukovinaError => e
      @errors << e
      nil ; end

   protected

   def parse_hash event
      result = {}

      result[:memory] = { short_name: "^#{target}" } if target

      event.each do |key, value|
         case SUBPARSERS[ key ]
         when Symbol
            send(SUBPARSERS[ key ], value, result)
         when Array
            name = SUBPARSERS[ key ].first
            result[ name ] = SUBPARSERS[ key ].last.constantize.new.parse(value)
         when NilClass
            @errors << Parsers::BukovinaInvalidKeyNameError.new( "Invalid " +
               "key '#{key}' for 'event' specified" )
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "Invalid " +
               "key value '#{SUBPARSERS[ key ]}' for '#{key}' for 'event' " +
               "specified" )
         end
      end

      result ;end

   def year value, result
      result[ :date ] = value =~ /^\d+$/ && value.to_i || value ;end

   def calendary value, result
      if /^(#{CALENDARIES.join("|")})$/ =~ value.to_s
         result[ :slug ] = { text: value.to_s }
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "invalid calendary " +
            "value '#{value}' detected for calendary field" )  ;end;end

   def author value, result
      result[ :author_name ] = value; end

   def link value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::Link.new
         if res = parser.parse(value)
            result[ :links ] ||= []
            result[ :links ].concat(res.delete(:link))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid link " +
            "'#{value}' detected" ) ;end;end

   def desc value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::Description.new
         if res = parser.parse(value)
            result[ :descriptions ] ||= []
            result[ :descriptions ].concat(res.delete(:description))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid description " +
            "'#{value}' detected" ) ;end;end

   def name value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::Description.new
         if res = parser.parse(value)
            result[ :names ] ||= []
            result[ :names ].concat(res.delete(:description))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid name " +
            "'#{value}' detected" ) ;end;end

   def council value, result
      if /^(#{COUNSILS.join("|")})$/ =~ value
         result[ :council ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "invalid item " +
            "value '#{value}' detected for council field" ) ;end;end

   def place value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::Description.new
         if res = parser.parse(value)
            result[ :place ] ||= {}
            result[ :place ][ :descriptions ] ||= []
            result[ :place ][ :descriptions ].concat(res.delete(:description))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid place " +
            "(value #{value}' detected" ) ;end;end

   def wiki value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::Link.new
         if res = parser.parse(value)
            result[ :wikies ] ||= []
            result[ :wikies ].concat(res.delete(:link))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid wikies " +
            "'#{value}' detected" ) ;end;end

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_line line, language_code = 'ру'
      language_code = language_code.to_sym

      if ! Parsers::MATCH_TABLE[ language_code ]
         @errors << Parsers::BukovinaInvalidLanguageError.new( "Invalid " +
            "language '#{language_code}' specified" )
         nil
      else
         if Parsers::MATCH_TABLE[ language_code ] =~ line.gsub(/[0-9\s‑';:"«»,()\.\-\?\/]/,'')
            line
         else
            @errors << Parsers::BukovinaInvalidCharError.new( "Invalid " +
               "char(s) for language '#{language_code}' specified" )
            nil ; end ; end ; end

   def initialize
      @errors = [] ; end ; end

