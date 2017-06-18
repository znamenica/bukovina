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
      'месяцеслов' => :calendary,
      'собор' => :ignore,
      'описание' => :type,
      'служба' => :service,
      'по' => :after,
      'пред' => :before,
      'навеч' => :inevening,
   }

   EVENTS = Bukovina::Parsers::Event::EVENTS

   DAY = %w(пн вт ср чт пт сб нд дн)
   PREF = %w(до по близ)
   DATES = %w(пасхе пасхи пасха)

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

      # expand calendary string
      res[:memos ] = res[ :memos ].map do |memo|
         if memo[ :calendary_string ].to_s =~ /,/
            memo[ :calendary_string ].split(/,\s*/).map do |cal|
               new_memo = memo.deep_dup
               new_memo[ :calendary_string ] = cal
               new_memo ;end
         else
            memo ;end;end
         .flatten

      @errors.empty? && res || nil

   rescue Parsers::BukovinaError => e
      @errors << e
      nil ; end

   protected

   def events
      @events ||= (EVENTS.keys | %w(само)).join('|')
   end

   def parse_hash memo
      result = {}

      result[:memory] = { short_name: "^#{target}" } if target

      memo.each do |key, value|
         case SUBPARSERS[ key ]
         when Symbol
            send(SUBPARSERS[ key ], value, result)
         when Array
            name = SUBPARSERS[ key ].first
            result[ name ] = SUBPARSERS[ key ].last.constantize.new.parse(value)
         when NilClass
            @errors << Parsers::BukovinaInvalidKeyNameError.new( "Invalid " +
               "key '#{key}' for 'memo' specified" )
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "Invalid " +
               "key value '#{SUBPARSERS[ key ]}' for '#{key}' for 'memo' " +
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
         if /^((#{DAY.join("|")})(\.\d+)?\.(#{PREF.join("|")}))?\s*(\d{1,2}\.\d{2}|#{DATES.join("|")})$/ =~ v
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
         if /^(#{Bukovina::Parsers::Calendary::CALENDARIES.join("|")})$/ =~ v
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
      value.split(",").map do |v|
         if /^(#{events})(:?\.(\d+))??$/ =~ v
            event = $1
            number= $2

            res = {}
            res[ :type_class ] = EVENTS[ event ] if EVENTS[ event ]
            res[ :type_number ] = number if number
            result[ :event_memos ] ||= []
            result[ :event_memos ] << res
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "Memo type (description) '#{v}' is invalid" ) ;end;end;end

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def service value, result
      case value
      when String, Hash, Array
         service_link = Bukovina::Parsers::ServiceLink.new
         res = service_link.parse(value, target: target)

         if service_link.errors.empty?
            if res[ :link ].present?
               result[ :service_links ] ||= []
               result[ :service_links ].concat(res.delete(:link))
            end

            if res[ :service ].present?
               result[ :services ] ||= []
               result[ :services ].concat(res.delete(:service))
            end
         else
            @errors.concat(service_link.errors)
         end

      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid service " +
            "'#{value}' detected" )
      end
   end

   def before value, result
      if value.to_s =~ /^\d+$/
         result[ :before ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Memo before value '#{value}' is invalid" )
      end;end

   def after value, result
      if value.to_s =~ /^\d+$/
         result[ :after ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Memo after value '#{value}' is invalid" )
      end;end

   def inevening value, result
      if value.to_s =~ /^\d+$/
         result[ :inevening ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Memo inevening value '#{value}' is invalid" )
      end;end

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
