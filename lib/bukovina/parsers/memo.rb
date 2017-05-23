#require 'lib/bukovina/parsers/event.rb'

class Bukovina::Parsers::Memo
   attr_reader :errors, :target

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   SUBPARSERS = {
      'год' => :year,
      'дата' => :date,
      'календарь' => :calendary,
      'собор' => :ignore,
      'описание' => :type,
   }

   TYPES = Bukovina::Parsers::Event::EVENTS.keys | %w(само)

   DATE_PRES = %w(нд.по нд.до сб.по сб.до)
   DATES = [ 'пт.вел', 'сб.по рх', 'нд.7.по пасхе', 'вс.8.по пасхе', 'ср.1.по пасхе', 'вт.1.по пасхе', 'сб.5.поста', 'сб.по отд.вздв',
              'вт.1.по пасхе', 'чт.по всех' ]

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

   def parse memos, options = {}
      # TODO skip return if errors found
      #
      @target = options[:target]

      res =
      case memos
      when Hash
         memo = parse_hash( memos )

         { memos: [ memo ] }
      when Array
         if memos.blank?
            @errors << Parsers::BukovinaInvalidValueError.new( "Value of memo " +
               "array is empty" ) ;end

         list = memos.map do |memo|
            parse_hash( memo )
         end.compact

         { memos: list }
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
      result[ :happened_at ] = value =~ /^\d+$/ && value.to_i || value  ;end

   def date value, result
      value = value.is_a?(Float) && sprintf("%.2f", value) || value.to_s

      abouts =
      value.split(',').map do |v|
         case v.strip
         when /^(#{DATE_PRES.join("|")})?\s*(\d{1,2}\.\d{2})$/
            sprintf("%s %.2f", $1, $2)
         when /^(?:#{DATES.join("|")})$/
            v
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "Invalid memo date " +
               "value #{value}' detected" ) ;end;end

      if abouts.all?
         result[ :date ] = abouts.join(',') ;end
   rescue ArgumentError => e
      binding.pry
   rescue TypeError => e
      e.message << " for type value: #{value}, and result: #{result.inspect}"
      @errors << e ;end

   def calendary value, result
      cals = value.to_s.split(',')

      parsed = cals.map do |v|
         if /^(#{CALENDARIES.join("|")})$/ =~ v
            v
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "invalid calendary " +
               "value '#{v}' detected for calendary field" )
            nil ;end;end
      .compact

      if (cals - parsed).empty?
         result[ :calendary_string ] = value ;end;end

   def ignore value, result ;end

   def type value, result
      if /^(#{TYPES.join("|")})$/ =~ value
         result[ :memo_type ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "invalid type " +
            "value '#{value}' detected for description (type) field" ) ;end;end

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
