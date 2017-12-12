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
         parsed = parse_hash( memos )
         memos = post_hash_proc( parsed )

         { memos: memos }
      when Array
         if memos.blank?
            @errors << Parsers::BukovinaInvalidValueError.new( "Value of memo " +
               "array is empty" ) ;end

         list = memos.map do |memo|
            parsed = parse_hash( memo )
            post_hash_proc( parsed )
         end.flatten.compact

         { memos: list }
      when NilClass
         @errors << Parsers::BukovinaInvalidValueError.new( "Event list" +
            "can't be blank" )
      else
         raise Parsers::BukovinaInvalidClass, "Invalid class #{name.class} " +
            "for Memo line '#{name}'" ; end

      @errors.empty? && res || nil

   rescue Parsers::BukovinaError => e
      @errors << e
      nil ; end

   protected

   def events
      @events ||= (EVENTS.keys | %w(само)).join('|')
   end

   def post_hash_proc in_memo
      result =
      [ in_memo ].flatten.map do |memo|
         #fix year date
         date = memo[:year_date]

         if /пасха/ =~ date
            date = '+0'
         elsif /дн.(\d+).по пасхе/ =~ date
            date = "+#{$1}"
         elsif /нд.по пасхе/ =~ date
            date = "+7"
         elsif /нд.(\d+).по пасхе/ =~ date
            date = "+#{$1.to_i * 7}"
         elsif /нд.до пасхи/ =~ date
            date = "-7"
         elsif /нд.(\d+).до пасхи/ =~ date
            date = "-#{$1.to_i * 7}"
         elsif /дн.(\d+).до пасхи/ =~ date
            date = "-#{$1}" ;end

         memo[:year_date] = date
         memo ;end

      result =
      result.flatten.map do |memo|
         be_i = memo.delete(:before).to_i
         in_i = memo.delete(:inevening).to_i
         af_i = memo.delete(:after).to_i

         be = (-be_i - in_i...-in_i).map do |i|
            new_memo = memo.deep_dup
            new_memo[:year_date] = sub_date(memo[:year_date], i)
            new_memo[:bond_to_marker] = memo[:year_date]
            new_memo[:bind_kind] = 'предпразднество'
            new_memo
         end
         ie = (-in_i...0).map do |i|
            new_memo = memo.deep_dup
            new_memo[:year_date] = sub_date(memo[:year_date], i)
            new_memo[:bond_to_marker] = memo[:year_date]
            new_memo[:bind_kind] = 'навечерие'
            new_memo
         end
         af = (1...af_i + 1).map do |i|
            new_memo = memo.deep_dup
            new_memo[:year_date] = sub_date(memo[:year_date], i)
            new_memo[:bond_to_marker] = memo[:year_date]
            new_memo[:bind_kind] = 'попразднество'
            new_memo
         end
         [ memo, be, ie, af ] ;end
      .flatten

      result =
      result.map do |memo|
         events = memo[:event].split(/\s*,\s*/)
         events.map do |value|
            event = {}
            value = 'почит' if value == 'само'
            if /^(#{Bukovina::Parsers::Event::EVENTS.keys.join("|")})(?:\.(\d+))??$/ =~ value
               event[ :type ] = EVENTS[ $1 ]
               event[ :type_number ] = $2 if $2
            else
               raise
               ;end

            event[ :memory ] = { short_name: target } if target

            new_memo = memo.deep_dup
            new_memo[ :event ] = event
            new_memo ;end;end
      .flatten

      result =
      result.map do |memo|
         memo.delete(:calendary_string).to_s.split(/\s*,\s*/).map do |cal|
            new_memo = memo.deep_dup
            new_memo[ :calendary ] = { slugs: { text: cal }}
            new_memo ;end;end
      .flatten

      result ;end

   def sub_date date, idx
      days = [31,29,31,30,31,30,31,31,30,31,30,31]

      if /(?<day>\d+)\.(?<month>\d+)/ =~ date
         new_day = day.to_i + idx
         new_month = month.to_i
         if new_day > days[new_month - 1]
            new_day -= days[new_month - 1]
            new_month += 1
            if new_month > 12
               new_month = 1 ;end
         elsif new_day < 1
            new_month -= 1
            if new_month < 1
               new_month = 12 ;end
            new_day += days[new_month - 1]
         end
         sprintf("%02i.%02i", new_day, new_month)
      elsif /(?<day>[+-]\d+)/ =~ date
         new_day = day.to_i + idx
         sprintf("%+i", new_day)
      else
         raise "Invalid format date is: #{date}" ;end;end

   def parse_hash memo
      result = {}

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
      result[ :add_date ] = value =~ /^\d+$/ && value.to_i || value  ;end

   def date value, result
      if value.is_a?(Float) || value =~ /(\d+)\.(\d+)/
         float = value.is_a?(String) && value.to_f || value
         int = float.to_i
         mod = ((float - int + 0.0099999)*100).to_i
         value = sprintf("%02i.%02i", int, mod)
      end

      abouts =
      value.split(',').map do |v|
         if /^((#{DAY.join("|")})(\.\d+)?\.(#{PREF.join("|")}))?\s*(\d{1,2}\.\d{2}|#{DATES.join("|")})$/ =~ v
            v
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "Invalid memo date " +
               "value #{value}' detected" ) ;end;end

      if abouts.all?
         result[ :year_date ] = abouts.join(',') ;end
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
      if value.to_s !~ /^$/
         result[ :event ] = value
      else
#      value.split(",").map do |v|
#         if /^(#{events})(:?\.(\d+))??$/ =~ v
#            event = $1
#            number= $2
#
#            res = {}
#            res[ :type_class ] = EVENTS[ event ] if EVENTS[ event ]
#            res[ :type_number ] = number if number
#            result[ :event_memos ] ||= []
#            result[ :event_memos ] << res
#         else
         @errors << Parsers::BukovinaInvalidValueError.new( "Memo type (description) '#{value}' is invalid" ) ;end;end;#end

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
