class Bukovina::Parsers::Memory
   attr_reader :errors, :target

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   SUBPARSERS = {
      'имя' => :name,
      'отчество' => :patronymic,
      'прозвище' => :nickname,
      'фамилия' => :lastname,
      'описание' => :desc,
      'чин' => :order,
      'собор' => :counsil,
      'вики' => :wiki,
      'бытие' => :link,
      'образ' => :icon,
      'отечник' => :pateric,
      'служба' => :service,
      'событие' => :event,
      'помин' => :memo,
   }

   COUNSILS = %w(рус греч иерс аме фин болг серб груз пол рум чсл виз алкс антх
                 карф рим англ
                 мск киев черн сузд верн нов нпск влдв
                 молд кит укр клвн блр русз герм
                 пнаф печ
                 плст
                )
   ORDERS = %w(нмр нмч нмк 17мг нмм нмс нмз 1рс нмб
               сщмч сщмчч вмц вмч мч мцц мчч прмч прмц мц прп прав свт прпж стцц стц блж сщисп присп присц исп исц блгв блгвв рап стсвт
               сбр
               кит
               мск спб вят перм ниж сиб каз влад тавр уф тул ряр врнж сарн вуст кстр нов твер мурм клзн ека крсн кур влгд нсиб
                   сам тамб кар ряз влгр рнд пск ива омск верн астр кург симб
               опт пнаф пппр мсвт смнк бпеч рднж нмнд валм сол див
               укр киев елсг неж жит вол карп гал вин черк одес херс полт крмч мрпл хуст черн кнтп
               молд
               блр нгрд
               серб шбцв)

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

      result
   end

   def name value, result, method_name = :name
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::Name.new
         res = parser.parse(value)

         if parser.errors.empty?
            if res[ :name ].present?
               result[ :name ] ||= []
               result[ :name ].concat(res.delete(:name)) ;end
         else
            @errors.concat(parser.errors) ;end

      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid service " +
            "'#{value}' detected" ) ;end;end

   def patronymic value, result
     name(value, result, :patronymic) ;end

   def nickname value, result
     name(value, result, :nickname) ;end

   def lastname value, result
     name(value, result, :lastname) ;end

   def counsil value, result
      cous = value.to_s.split(',')

      parsed = cous.map do |v|
         if /^(#{COUNSILS.join("|")})$/ =~ v.sub('?', '')
            v
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "invalid " +
               "value '#{v}' detected for counsil field" )
            nil ;end;end
      .compact

      if (cous - parsed).empty?
         result[ :counsil ] = value ;end;end

   def order value, result
      match =
      value.split(',').all? do |v|
         /^(#{ORDERS.join("|")})/ =~ v
      end

      if match
         result[ :order ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid " +
            "value '#{value}' detected for order field" )
      end
   end

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
            "'#{value}' detected" )
      end
   end

   def icon value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::IconLink.new
         if res = parser.parse(value)
            result[ :icon_links ] ||= []
            result[ :icon_links ].concat(res.delete(:icon_link))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid icon link " +
            "'#{value}' detected" ) ;end;end

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

   def pateric value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::Link.new
         if res = parser.parse(value)
            result[ :paterics ] ||= []
            result[ :paterics ].concat(res.delete(:link))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid pateric link " +
            "'#{value}' detected" ) ;end;end

   def event value, result
      case value
      when Hash, Array
         parser = Bukovina::Parsers::Event.new
         if res = parser.parse(value)
            result[ :events ] ||= []
            result[ :events ].concat(res.delete(:event))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid event value " +
            "'#{value}' detected" ) ;end;end

   def memo value, result
      case value
      when Hash, Array
         parser = Bukovina::Parsers::Memo.new
         if res = parser.parse(value)
            result[ :memos ] ||= []
            result[ :memos ].concat(res.delete(:memos))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid memos value " +
            "'#{value}' detected" ) ;end;#end
         rescue
            binding.pry
         end

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
