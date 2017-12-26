class Bukovina::Parsers::Event
   attr_reader :errors, :target

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   SUBPARSERS = {
      'год' => :year,
      'дата' => :date,
      'время' => :time,
      'описание' => :type,
      'предмет' => :item,
      'место' => :place,
      'образ' => :icon,
      'бытие' => :link,
      'ссылка' => :link,
      'описание_' => :desc,
      'вики' => :wiki,
      'супруг' => :person,
      'муж' => :person,
      'жена' => :person,
      'кем' => :person,
      'кому' => :person,
      'чадо' => :person,
#      'служба' => :service,
      'о' => :about,
      'собор' => :council,
      'чин' => :order,
      'тез' => :tezo,
      'координаты' => :coord,
   }

   ITEMS = [
      'частица',
      'глава',
      'глава.часть',
      'челюсть',
      'десница',
      'шуйца',
      'рука',
      'позвонок',
      'глезно',
      'длань',
      'длань шуя',
      'длань.часть',
      'кожа',
      'плечо',
      'цепь',
      'вериги',
      'оковы',
      'часть',
      'часть веляя',
      'посох',
      'покров',
      'деснога',
      'шуйнога',
      'стопа',
      'тело',
      'зуб',
      'предплечье',
      'список',
      'оковы',
      'цепь',
      'решётка',
   ]

   EVENTS = {
      'бесе' => 'Tale',              # от(чел)-ко(чел) # Беседа/Благовещение
      'битва' => 'Battle',           # ч(место)
      'блгдр' => 'Thanksgiving',     # ко(лич) ЧИНИ какое событие, или просто добвить поле норов (характер) в помин, а событие поставить иное?
      'блслв' => 'Benediction',      # от(стын:self)-ко(чел:person)
      'бвщ' =>  => 'Annunciation',   # кого
      'брак' => 'Marriage',          # от(чел:self)-ко(чел:person)
      'вздв' => 'Exaltation',        # ч(стын:self),кем(чел:person)
      'вид' => 'Apparation',         # ч(стын:self)-ко(чел:person)
      'вознс' => 'Ascension',        # кого(чел:self)
      'вопл' => 'Incarnation',       # кого
      'воин' => 'SoldierMemory',     # ч(поместо) память павших воинов
      'восст' => 'Restoration',      # к(чел:self)
      'вскрс' => 'Resurrection',     # к(чел:само)
      'вход' => 'Entrance',          # от(чел)
      'дияк' => 'Deaconry',          # к(чел:само)-кем(чел:person)
      'ересь' => 'Enheresment',      # к(чел:само)
      'заржд' => 'Conception',       # кого(чел:само)
      'застп' => 'Protection',       # от(стын:сало)-к(чел:лично) # покров?
      'зач' => 'Conceiving',         # кем(чел:само)-кого(чел:лично)
      'знам' => 'Portent',           # ч(стын) # ЧИНИ? может быть ттоже что и (по)явление?
      'избав' => 'Deliverance',      # ч(стын) # ЧИНИ? может быть победа над кем-то?
      'изме' => 'Betraial',          # ко(чел)
      'изнес' => 'Procession',       # ч(стын)-кем(чел:person)
      'иноч' => 'Monasticry',        # ко(чел)-кем(чел:person)
      'ипод' => 'Hypodeaconry',      # ко(чел)-кем(чел:person)
      'крещ' => 'Baptism',           # ко(чел)-кем(чел:person)
      'надст' => 'Superstructure',   # ч(стын)-кем(собор:person)
      'напис' => 'Writing',          # ч(обр)-кем(чел:person)
      'науч' => 'Learning',          # от(чел)
      'нем' => 'Numbness',           # ко(чел) # ЧИНИ может чудо?
      'низл' => 'Deposition',        # ко(чел)-кем(собор:person)
      'обн' => 'Sanctification',     # ч(храм)-кем(собор:person)
      'обр' => 'Uncovering',         # ч(стын)-кем(чел:person)
      'обрез' => 'Circumcision',     # ко(чел)
      'ожив' => 'Revival',           # от(чел)-ко(чел)
      'освоб' => 'Liberation',       # ко(чел)
      'отр' => 'Renunciation',       # от(чел)
      'пад' => 'Fall',               # ч(место)
      'пгрб' => 'Burial',            # ко(чел)
      'пожар' => 'GreatFire',        # ч(место)
      'покая' => 'Repentance',       # от(чел)-кто прнимал(чел:person)
      'покой' => 'Rest',             # от(чел)-ко(собор:person)
      'полож' => 'Placing',          # ч(стын)
      'почит' => 'Veneration',       # ч(стын)
      'прдст' => 'Primacy',          # от(чел)
      'прел' => 'PuttingInAgain',    # ч(стын)
      'прем' => 'Teleportation',     # ч(стын)
      'прен' => 'Translation',       # ч(стын)
      'призв' => 'Calling',          # ко(чел)
      'плен' => 'Captivity',         # ч(предм)
      'покл' => 'Adoration',         # ко(чел)-от(собор:person)       # приношение, поклонение (волхвов)
      'преоб' => 'Transfiguration',  # ко(чел)
      'прок' => 'Curse',             # от(чел)
      'проп' => 'Preach',            # от(чел)
      'пррч' => 'Prophecy',          # от(чел)-кем(person)
      'просл' => 'Canonization',     # от(чел)-кем(собор:person)
      'прств' => 'Repose',           # от(чел)
      'прстл' => 'Throne',           # ч(храм)
      'разр' => 'Destruction',       # ч(храм)
      'раск' => 'Schism',            # от(чел)
      'распп' => 'Defrocking',       # ко(чел)
      'рассл' => 'Decanonization',   # от(чел)
      'ржд' => 'Nativity',           # от(чел)
      'рясф' => 'Frockbearing',      # ко(чел)-кем(чел:person)
      'сбр' => 'Council',            # ч(место)
      'свят' => 'Bishopry',          # ко(чел)-кем(собор:person)
      'свящ' => 'Priestship',        # ко(чел)-кем(чел:person)
      'созд' => 'Founding',          # ч(храм)
      'сокр' => 'Hiddening',         # ч(стын)
      'соявл' => 'Phenomenon',       # ко(чел)-от(чел:person)
      'срет' => 'Meeting',           # от(чел)-ко(чел)
      'стрст' => 'Passion',          # ко(чел)
      'схим' => 'Schima',            # ко(чел)
      'тайн' => 'Supper',            # от(чел)-ко(собор:person)
      'трез' => 'Sobriety',          # ч(поместо) память трезвения
      'труд' => 'Labor',             # от(чел) # ЧИНИ что это?
      'тряс' => 'Earthquake',        # ч(место)
      'увер' => 'Assurance',         # от(чел)-ко(чел)
      'утр' => 'Loss',               # ч(стын)
      'чинпр' => 'Glorification',    # ко(чел)-от(собор:person)
      'чтец' => 'Reader',            # ко(чел)-кем(чел:person)
      'чудо' => 'Miracle',           # ч(стын)
      'явл' => 'Appearance',         # ч(обр)
   }
# навеч - eve
# отд - Apodosis
# попр - Afterfeast
# пред - Forefeast
# само - feast
   #
   COUNSILS = %w(рус греч иерс аме фин болг серб груз пол рум чсл виз алкс антх
                 карф рим англ
                 мск киев черн сузд верн нов нпск влдв
                 молд кит укр клвн блр русз герм
                 пнаф печ)
   ORDERS = %w(нмр нмч нмк 17мг нмм нмс нмз 1рс нмб
               сщмч сщмчч вмц вмч мч мцц мчч прмч прмц мц прп прав свт прпж стцц стц блж сщисп присп присц исп исц блгв блгвв рап
               сбр
               кит
               мск спб вят перм ниж сиб каз влад тавр уф тул ряр врнж сарн вуст кстр нов твер мурм клзн ека крсн кур влгд нсиб
                   сам тамб кар ряз влгр рнд пск ива омск верн астр кург симб
               опт пнаф пппр мсвт смнк бпеч рднж нмнд валм сол див
               укр киев елсг неж жит вол карп гал вин черк одес херс полт крмч мрпл хуст черн кнтп глин
               молд
               блр нгрд
               мхп
               серб шбцв)
   ABOUT_PRES = %w(нд.по нд.до сб.по сб.до)
   ABOUTS = [ 'пт.вел', 'сб.по рх', 'нд.7.по пасхе', 'вс.8.по пасхе', 'ср.1.по пасхе', 'вт.1.по пасхе', 'сб.5.поста', 'сб.по отд.вздв',
              'вт.1.по пасхе', 'чт.по всех', 'чт.9.по пасхе' ]

   def parse events, options = {}
      # TODO skip return if errors found
      #
      @target = options[:target]

      res =
      case events
      when Hash
         event = parse_hash( events )
         events = post_hash_proc( event )

         { event: events }
      when Array
         if events.blank?
            @errors << Parsers::BukovinaInvalidValueError.new( "Value of event " +
               "array is empty" ) ;end

         event_list = events.map do |event|
            parse_hash( event )
         end.compact
         events = post_hash_proc( event_list )

         { event: events }
      when NilClass
         @errors << Parsers::BukovinaInvalidValueError.new( "Event list" +
            "can't be blank" )
      else
         raise Parsers::BukovinaInvalidClass, "Invalid class #{name.class} " +
            "for Event line '#{name}'" ; end

      @errors.empty? && res || nil

   rescue Parsers::BukovinaError => e
      @errors << e
      nil ; end

   def post_hash_proc in_event
      events = [ in_event ].flatten
         
      if !events.find { |e| e[:type] == 'Veneration' }
         happened_at = events.last[:happened_at]
         events << {
            happened_at: happened_at.is_a?(Array) && happened_at.first || happened_at,
            type: 'Veneration',
         } ;end

      events ;end

   protected

   def parse_hash event
      result = {}

      # result[:memory] = { short_name: "^#{target}" } if target

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

   def year value, result
      ats = value.to_s.split('/').map {|x| x =~ /^\d+$/ && x.to_i || x }

      if ats.empty?
         @errors << Parsers::BukovinaInvalidValueError.new( "Year value " +
            "isn't defined" )
         return
      end

      new =
      case result[ :happened_at ]
      when NilClass
         ats
      when Array
         if not result[ :happened_at ]
            @errors << Parsers::BukovinaInvalidValueError.new( "Data array is already defined as #{result[ :happened_at ]}")
            nil
         else
            [ result[ :happened_at ], ats ].transpose.map do |(date, year)|
               if date =~ /-/
                  if year =~ /-/
                     [ date.split(/-/), year.split('-') ].transpose.map { |x| x.join('.') }.join('-')
                  else
                     date.split(/-/).map { |d| [ d, year ].join('.') }.join('-')
                  end
               else
                  if year =~ /-/
                     year.split(/-/).map { |y| [ date, y ].join('.') }.join('-')
                  else
                     [ date, year ].join('.')
                  end
               end.join('-')
            end
         end
      else
         dats = result[ :happened_at ].split('-')
         dats.map { |dat| ats.map { |x| "#{dat}.#{x}" } }
      end

      result[ :happened_at ] = new.size == 1 && new.pop || new
      if result[ :happened_at ] =~ /Time can't be used without a previously defined date/
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid resulted value: #{result[ :happened_at ]}") ;end

      result[ :happened_at ] ;end

   def date value, result
      ats = value.to_s.split('/').map { |x| x =~ /.1$/ && "#{x}0" || x }

      return if ats.empty?

      new =
      case result[ :happened_at ]
      when NilClass
         @errors << Parsers::BukovinaInvalidValueError.new( "Time " +
            "can't be used without a previously defined date in #{value}" )
      when Array
         preres =
         if ats.size == result[ :happened_at ].size
            [ ats, result[ :happened_at ] ].transpose
         else
            ats.product(result[ :happened_at ])
         end

         preres.map do |(date, year)|
            if date =~ /-/
               if year =~ /-/
                  [ date.split(/-/), year.split('-') ].transpose.map { |x| x.join('.') }.join('-')
               else
                  date.split(/-/).map { |d| [ d, year ].join('.') }.join('-')
               end
            else
               if year =~ /-/
                  year.split(/-/).map { |y| [ date, y ].join('.') }.join('-')
               else
                  [ date, year ].join('.')
               end
            end
         end
      else
         ats.map { |x| "#{x}.#{result[ :happened_at ]}" }
      end

      result[ :happened_at ] = new.size == 1 && new.pop || new
   end

   def time value, result
      ats = value.to_s.split('/').map { |x| x =~ /.1$/ && "#{x}0" || x }

      return if ats.empty?

      new =
      case result[ :happened_at ]
      when NilClass
         ats
      when Array
         if ats.size != result[ :happened_at ].size
            if ats.size > 1
               binding.pry
               @errors << Parsers::BukovinaInvalidValueError.new( "Array " +
                  "size for date value doesn't match to stored one" )
               ''
            else
               newats = ats * result[ :happened_at ].size
               [ newats, result[ :happened_at ] ].transpose.map { |x| x.join(".") }
            end
         else
            [ ats, result[ :happened_at ] ].transpose.map do |(date, year)|
               if date =~ /-/
                  if year =~ /-/
                     [ date.split(/-/), year.split('-') ].transpose.map { |x| x.join('.') }.join('-')
                  else
                     date.split(/-/).map { |d| [ d, year ].join('.') }.join('-')
                  end
               else
                  if year =~ /-/
                     year.split(/-/).map { |y| [ date, y ].join('.') }.join('-')
                  else
                     [ date, year ].join('.')
                  end
               end
            end
         end
      else
         ats.map { |x| "#{x}.#{result[ :happened_at ]}" }
      end

      result[ :happened_at ] = new.size == 1 && new.pop || new
   end

   def council value, result
      if /^(#{COUNSILS.join("|")})$/ =~ value
         result[ :council ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "invalid item " +
            "value '#{value}' detected for council field" )
      end
   end

   def order value, result
      match =
      value.split(',').all? do |v|
         /^(#{ORDERS.join("|")})/ =~ v
      end

      if match
         result[ :order ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid item " +
            "value '#{value}' detected for order field" )
      end
   end

   def tezo value, result
      _in = value.split(/,.*/)
      _out = _in.map do |v|
         list = Dir.glob('../*').map { |x| x =~ /..\/(.*)/ && $1 || nil }.compact
         if list.include?(v.gsub(/вид.\s*/, ''))
            v
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "Event tezo '#{value}' isn't found in list of memories" )
            nil ;end;end.compact

      if _out.size == _in.size
         result[ :tezo_string ] = value ;end;end

   def item value, result
      /^(#{ITEMS.join("|")})(\.\d+)?$/ =~ value
      itemname = $1

      if itemname.present?
         item = {
            item_type: {
               descriptions: [ {
                  alphabeth_code: :ру,
                  language_code: :ру,
                  text: value } ] } }
         result[ :item ] = item
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid item " +
            "value '#{value}' detected for item field" )
      end
   end

   def type value, result
      /^(#{EVENTS.keys.join("|")})(?:\.(\d+))??$/ =~ value
      event = $1
      number= $2

      if EVENTS[ event ].present?
         result[ :type ] = EVENTS[ event ]
         result[ :type_number ] = number if number
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid event " +
            "'#{value}' detected" ) ;end
   rescue TypeError => e
      e.message << " for type value: #{value}, and result: #{result.inspect}"
      @errors << e ;end

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
            "(value #{value}' detected" )
      end
   end

   def about value, result
      value = value.is_a?(Float) && sprintf("%.2f", value) || value

      abouts =
      value.split(',').map do |v|
         case v.strip
         when /^(#{ABOUT_PRES.join("|")})?\s*(\d{1,2}\.\d{2})$/
            sprintf("%s %.2f", $1, $2)
         when /^(?:#{ABOUTS.join("|")})$/
            v
         else
            @errors << Parsers::BukovinaInvalidValueError.new( "Invalid about " +
               "value #{value}' detected" ) ;end
      end

      if abouts.all?
         result[ :about_string ] = abouts.join(',') ;end
   rescue ArgumentError => e
      binding.pry
   rescue TypeError => e
      e.message << " for type value: #{value}, and result: #{result.inspect}"
      @errors << e ;end

   def person value, result
      case value
      when String
         result[ :person_name ] = value
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid person " +
            "(whom/spouse) value #{value}' detected" )
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

   def coord value, result
      case value
      when String, Hash, Array
         parser = Bukovina::Parsers::Link.new
         if res = parser.parse(value)
            result[ :coordinate ] = res.delete(:link).first
         else
            @errors.concat(parser.errors) ;end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid coordinate link " +
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
