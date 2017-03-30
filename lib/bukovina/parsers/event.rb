class Bukovina::Parsers::Event
   attr_reader :errors

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   SUBPARSERS = {
      'год' => :year,
      'дата' => :date,
      'описание' => :type,
      'предмет' => :item,
      'место' => :place,
      'образ' => :icon,
      'бытие' => :link,
      'ссылка' => :link,
      'описание_' => :desc,
      'вики' => :wiki,
      'супруг' => :person,
      'кем' => :person,
      'чадо' => :person,
      'служба' => :service,
      'о' => :about,
   }

   ITEMS = [
      'частица',
      'глава',
      'десница',
      'рука',
      'позвонок',
      'глезно',
      'длань',
      'длань шуя',
      'кожа',
      'плечо',
      'цепь',
      'вериги',
      'оковы',
      'часть',
      'часть веляя',
      'посох',
      'покров',
      'шуйца',
      'шуйнога',
      'тело',
      'зуб',
      'список',
   ]

   EVENTS = {
      'блгдр' => 'Thanksgiving',     # ко(лич) ЧИНИ какое событие, или просто добвить поле норов (характер) в помин, а событие поставить иное?
      'блслв' => 'Benediction',      # от(стын:self)-ко(чел:person)
      'брак' => 'Marriage',          # от(чел:self)-ко(чел:person)
      'вздв' => 'Exaltation',        # ч(стын:self),кем(чел:person)
      'вид' => 'Apparation',         # ч(стын:self)-ко(чел:person)
      'вознс' => 'Ascension',        # кого(чел:self)
      'восст' => 'Restoration',      # к(чел:self)
      'вскрс' => 'Resurrection',     # к(чел:само)
      'дияк' => 'Deaconry',          # к(чел:само)-кем(чел:person)
      'ересь' => 'Enheresment',      # к(чел:само)
      'заржд' => 'Conception',       # кого(чел:само)
      'застп' => 'Protection',       # от(стын:сало)-к(чел:лично) # покров?
      'зач' => 'Conceiving',         # кем(чел:само)-кого(чел:лично)
      'знам' => 'Portent',           # ч(стын) # ЧИНИ? может быть ттоже что и (по)явление?
      'избав' => 'Deliverance',      # ч(стын) # ЧИНИ? может быть победа над кем-то?
      'иноч' => 'Monasticry',        # ко(чел)-кем(чел:person)
      'ипод' => 'Hypodeaconry',      # ко(чел)-кем(чел:person)
      'крещ' => 'Baptism',           # ко(чел)-кем(чел:person)
      'надст' => 'Superstructure',   # ч(стын)-кем(собор:person)
      'напис' => 'Writing',          # ч(обр)-кем(чел:person)
      'нем' => 'Numbness',           # ко(чел) # ЧИНИ может чудо?
      'низл' => 'Deposition',        # ко(чел)-кем(собор:person)
      'обн' => 'Sanctification',     # ч(храм)-кем(собор:person)
      'обр' => 'Uncovering',         # ч(стын)-кем(чел:person)
      'ожив' => 'Revival',           # от(чел)-ко(чел)
      'освоб' => 'Liberation',       # ко(чел)
      'отр' => 'Renunciation',       # от(чел)
      'пгрб' => 'Burial',            # ко(чел)
      'покая' => 'Repentance',       # от(чел)-кто прнимал(чел:person)
      'полож' => 'Placing',          # ч(стын)
      'почит' => 'Veneration',       # ч(стын)
      'прдст' => 'Primacy',          # от(чел)
      'прел' => 'PuttingInAgain',    # ч(стын)
      'прен' => 'Translation',       # ч(стын)
      'призв' => 'Calling',          # ко(чел)
      'вход' => 'Entrance',          # от(чел)
      'просл' => 'Canonization',     # от(чел)-кем(собор:person)
      'прств' => 'Repose',           # от(чел)
      'прстл' => 'Throne',           # ч(храм)
      'разр' => 'Destruction',       # ч(храм)
      'раск' => 'Schism',            # от(чел)
      'распп' => 'Defrocking',       # ко(чел)
      'рассл' => 'Decanonization',   # от(чел)
      'ржд' => 'Nativity',           # от(чел)
      'рясф' => 'Frockbearing',      # ко(чел)-кем(чел:person)
      'свят' => 'Bishopry',          # ко(чел)-кем(собор:person)
      'свящ' => 'Priestship',        # ко(чел)-кем(чел:person)
      'созд' => 'Founding',          # ч(храм)
      'сокр' => 'Hiddening',         # ч(стын)
      'соявл' => 'Phenomenon',       # ко(чел)-от(чел:person)
      'срет' => 'Meeting',           # от(чел)-ко(чел)
      'стрст' => 'Passion',          # ко(чел)
      'схим' => 'Schima',            # ко(чел)
      'труд' => 'Labor',             # от(чел) # ЧИНИ что это?
      'утр' => 'Loss',               # ч(стын)
      'чинпр' => 'Glorification',    # ко(чел)-от(собор:person)
      'чтец' => 'Reader',            # ко(чел)-кем(чел:person)
      'чудо' => 'Miracle',           # ч(стын)
      'явл' => 'Appearance',         # ч(обр)
      'пожар' => 'GreatFire',        # ч(место)
      'тряс' => 'Earthquake',        # ч(место)
      'преоб' => 'Transfiguration',  # ко(чел)
      'изнес' => 'Procession',       # ч(стын)-кем(чел:person)
      'плен' => 'Captivity',         # ч(предм)
      'покл' => 'Adoration',         # ко(чел)-от(собор:person)       # приношение, поклонение (волхвов)
      'обрез' => 'Circumcision',     # ко(чел)
      'прок' => 'Curse',             # от(чел)
      'бесе' => 'Tale',              # от(чел)-ко(чел) # Беседа/Благовещение
      'изме' => 'Betraial',          # ко(чел)
      'пад' => 'Fall',               # ч(место)
      'науч' => 'Learning',          # от(чел)
      'покой' => 'Rest',             # от(чел)-ко(собор:person)
      'тайн' => 'Supper',            # от(чел)-ко(собор:person)
      'увер' => 'Assurance',         # от(чел)-ко(чел)
      'воин' => 'SoldierMemory',     # ч(поместо) память павших воинов
      'трез' => 'Sobriety',          # ч(поместо) память трезвения
   }
# навеч - eve
# отд - Apodosis
# попр - Afterfeast
# пред - Forefeast
# само - feast

   def parse events
      # TODO skip return if errors found
      #
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
         if ats.size != result[ :happened_at ].size
            @errors << Parsers::BukovinaInvalidValueError.new( "Array size for year value " +
               "doesn't match to stored one" )
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
   end

   def date value, result
      ats = value.to_s.split('/').map { |x| x =~ /.1$/ && "#{x}0" || x }

      return if ats.empty?

      new =
      case result[ :happened_at ]
      when NilClass
         ats
      when Array
         if ats.size != result[ :happened_at ].size
            if ats.size > 1
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
            "value '#{value}' detected" )
      end
   end

   def type value, result
      /^(#{EVENTS.keys.join("|")})$/ =~ value
      event = $1

      if EVENTS[ event ].present?
         result[ :type ] = EVENTS[ event ]
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid event " +
            "'#{value}' detected" )
      end
   end

   def place value, result
      case value
      when String, Hash, Array
         res = Bukovina::Parsers::Description.new.parse(value)
         result[ :place ] ||= {}
         result[ :place ][ :descriptions ] ||= []
         result[ :place ][ :descriptions ].concat(res.delete(:description))
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid place " +
            "(value #{value}' detected" )
      end
   end

   def about value, result
      /^(?<about>\d{2}\.\d{2})$/ =~ value

      if about.present?
         result[ :about_string ] = about
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid about " +
            "value #{value}' detected" )
      end
   end

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
         res = Bukovina::Parsers::ServiceLink.new.parse(value)
         result[ :service_links ] ||= []
         result[ :service_links ].concat(res.delete(:link))
         if res[ :service ].present?
            result[ :services ] ||= []
            result[ :services ].concat(res.delete(:service))
         end
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid service " +
            "'#{value}' detected" )
      end
   end

   def wiki value, result
      case value
      when String, Hash, Array
         res = Bukovina::Parsers::Link.new.parse(value)
         result[ :wikies ] ||= []
         result[ :wikies ].concat(res.delete(:link))
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid wikies " +
            "'#{value}' detected" )
      end
   end

   def icon value, result
      case value
      when String, Hash, Array
         res = Bukovina::Parsers::IconLink.new.parse(value)
         result[ :icon_links ] ||= []
         result[ :icon_links ].concat(res.delete(:icon_link))
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid icon links " +
            "'#{value}' detected" )
      end
   end

   def link value, result
      case value
      when String, Hash, Array
         res = Bukovina::Parsers::Link.new.parse(value)
         result[ :links ] ||= []
         result[ :links ].concat(res.delete(:link))
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid links " +
            "'#{value}' detected" )
      end
   end

   def desc value, result
      case value
      when String, Hash, Array
         res = Bukovina::Parsers::Description.new.parse(value)
         result[ :descriptions ] ||= []
         result[ :descriptions ].concat(res.delete(:description))
      else
         @errors << Parsers::BukovinaInvalidValueError.new( "Invalid description " +
            "'#{value}' detected" )
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
