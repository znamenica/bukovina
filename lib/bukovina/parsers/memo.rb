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

   COUNSILS = %w(рпц)

   TYPES = Bukovina::Parsers::Event::EVENTS.keys | %w(само)

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
      result[ :happened_at ] = value =~ /^\d+$/ && value.to_i || value  ;end

   def date value, result
      value = value.is_a?(Float) && sprintf("%.2f", value) || value

      abouts =
      value.split(',').map do |v|
         case v.strip
         when /^(#{ABOUT_PRES.join("|")})?\s*(\d{1,2}\.\d{2})$/
            sprintf("%s %.2f", $1, $2)
         when /^(?:#{ABOUTS.join("|")})$/
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
      if /^(#{CALENDARIES.join("|")})$/ =~ value
         result[ :calendary_string ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "invalid calendary " +
            "value '#{value}' detected for calendary field" )  ;end;end

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
