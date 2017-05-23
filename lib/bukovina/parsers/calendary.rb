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
      'собор' => :counsil,
   }

   CALENDARIES = %w(916
                    азар
                    ассе
                    афин
                    библ
                    библ
                    блап
                    болл
                    бпм
                    валл
                    взр1
                    взр2
                    влат
                    влбр
                    влчм
                    впдв
                    вскс
                    всрб
                    всс
                    вчм
                    гбмч
                    гдк
                    герм
                    гмин
                    гпм
                    греч
                    грм
                    грот
                    грхэ
                    гскс
                    джрж
                    длг
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
                    киж
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
                    пслт
                    пспр
                    пстгу
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
                    румо
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
                    ссм
                    стип
                    студ
                    супр
                    сурж
                    суст
                    твц
                    тырн
                    уцс
                    фип
                    флпс
                    флпс
                    хлуд
                    хрис
                    элл)

   DATE_PRES = %w(нд.по нд.до сб.по сб.до)
   DATES = [ 'пт.вел', 'сб.по рх', 'нд.7.по пасхе', 'вс.8.по пасхе', 'ср.1.по пасхе', 'вт.1.по пасхе', 'сб.5.поста', 'сб.по отд.вздв',
              'вт.1.по пасхе', 'чт.по всех' ]

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

      result[:memory] = { short_name: "*#{target}" } if target

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
      result[ :happened_at ] = value =~ /^\d+$/ && value.to_i || value ;end

   def calendary value, result
      if /^(#{CALENDARIES.join("|")})$/ =~ value.to_s
         result[ :calendary_string ] = value.to_s
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
            result[ :beings ] ||= []
            result[ :beings ].concat(res.delete(:link))
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
            result[ :name ] ||= []
            result[ :name ].concat(res.delete(:description))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid name " +
            "'#{value}' detected" ) ;end;end

   def counsil value, result
      if /^(#{COUNSILS.join("|")})$/ =~ value
         result[ :counsil ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "invalid item " +
            "value '#{value}' detected for counsil field" ) ;end;end

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

