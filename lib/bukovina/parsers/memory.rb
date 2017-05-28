class Bukovina::Parsers::Memory
   attr_reader :errors, :target

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   QUANTITIES = %w(много немного несколько)

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
      'слика' => :photo,
      'слики' => :photo,
      'отечник' => :pateric,
      'служба' => :service,
      'событие' => :event,
      'помин' => :memo,
      'крат' => :short,
      'количество' => :quantity,
      'вид' => :view,
      'покровительство' => :cover
   }

   COUNSILS = %w(стцц ап70
                 рус греч иерс аме фин болг серб груз пол рум чсл виз алкс антх
                 слав
                 карф мавр
                 рим
                 англ
                 мск киев черн сузд верн нов нпск влдв
                 молд кит укр клвн блр русз герм
                 пнаф печ
                 плст
                 нмр нмч нмк 17мг нмм нмс нмз 1рс нмб
                 кит
                 мск спб вят перм ниж сиб каз влад тавр уф тул ряр врнж сарн вуст кстр нов твер мурм клзн ека крсн кур влгд нсиб
                     сам тамб кар ряз влгр рнд пск ива омск верн астр кург симб
                 опт пнаф пппр мсвт смнк бпеч рднж нмнд валм сол див нсвт друс
                 укр киев елсг неж жит вол карп гал вин черк одес херс полт крмч мрпл хуст черн кнтп
                 молд
                 блр нгрд
                 серб шбцв
                 чсл чех свк мрв
                 зубц куп пгрл
                 сынм
                  )

   ORDERS = %w(св сщмч сщмчч вмц вмч мч мцц мчч прмч прмц мц прп прав свт прпж стц блж сщисп присп присц исп исц блгв блгвв рап стсвт мсвт исвт присп прор ап рап сщпр прсвт прстц бср блпр
               смчр пмчр пмцр мчр мцр мсвтр иср сщиср приср ицр прицр исвтр сщстц
               оспс обр оник озпр
               храм место обит прдм град
               спас бдц крлт бог
               сбт
               сбр правв брак стцц пстцц)

   def parse memories, options = {}
      # TODO skip return if errors found
      #
      @target = options[:target]

      res =
      case memories
      when Hash
         memory = parse_hash( memories )

         [ memory ]
      when Array
         if memories.blank?
            @errors << Parsers::BukovinaInvalidValueError.new( "Value of memory " +
               "array is empty" ) ;end

         memory_list = memories.map do |memory|
            parse_hash( memory )
         end.compact

         memory_list
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

   def parse_hash memory
      result = {}

      result[:memory] = { short_name: "*#{target}" } if target

      memory.each do |key, value|
         case SUBPARSERS[ key ]
         when Symbol
            send(SUBPARSERS[ key ], value, result)
         when Array
            name = SUBPARSERS[ key ].first
            result[ name ] = SUBPARSERS[ key ].last.constantize.new.parse(value)
         when NilClass
            @errors << Parsers::BukovinaInvalidKeyNameError.new( "Invalid " +
               "key '#{key}' for 'memory' specified" )
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "Invalid " +
               "key value '#{SUBPARSERS[ key ]}' for '#{key}' for 'memory' " +
               "specified" )
         end
      end

      result
   end

   def name value, result, method_name = :name
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers.const_get(method_name.to_s.camelize).new
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
     name(value, result, :nick_name) ;end

   def lastname value, result
     name(value, result, :last_name) ;end

   def counsil value, result
#      cous = value.to_s.split(',')
#
#      parsed = cous.map do |v|
#         if /^(#{COUNSILS.join("|")})$/ =~ v.sub('?', '')
#            v
#         else
#            @errors << Parsers::BukovinaInvalidValueError.new( "invalid " +
#               "value '#{v}' detected for counsil field" )
#            nil ;end;end
#      .compact
#
#      if (cous - parsed).empty?
         result[ :counsil ] = value ;end;#end

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

   def photo value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::IconLink.new
         if res = parser.parse(value)
            result[ :photo_links ] ||= []
            result[ :photo_links ].concat(res.delete(:icon_link))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid photo link " +
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

   def quantity value, result
      if /^(#{QUANTITIES.join("|")}|(ок\.|больше\s*)?\d+)$/ =~ value.to_s
         result[ :quantity ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid quantity " +
            "'#{value}' detected for memory" ) ;end;end

   def short value, result
      if /,/ !~ value.to_s
         result[ :short ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Short has a comma in '#{value}'" ) ;end;end

   def view value, result
      list = Dir.glob('../*').map { |x| x =~ /..\/(.*)/ && $1 || nil }.compact
      if list.include?(value)
         result[ :view_string ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Memory view '#{value}' isn't found in list of memories" ) ;end;end

   def cover value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::Description.new
         if res = parser.parse(value)
            result[ :cover ] ||= {}
            result[ :cover ][ :descriptions ] ||= []
            result[ :cover ][ :descriptions ].concat(res.delete(:description))
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Memory cover '#{value}' is invalid" )
      end
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
