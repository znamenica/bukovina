class Bukovina::Parsers::Event
   attr_reader :errors

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   SUBPARSERS = {
      'год' => :year, #proc { |data| data.split('/') },
      'дата' => :date, #proc { |data| data.split('/') },
      'описание' => :type, #TypeRE,
      'предмет' => :item,
      'место' => :place, #RE,
      'образ' => 'Bukovina::Parsers::IconLink',
      'бытие' => 'Bukovina::Parsers::BeingLink',
      'описание_' => 'Bukovina::Parsers::Description',
      'вики' => 'Bukovina::Parsers::WikiLink',
#      'служба' => 'Bukovina::Parsers::ServiceLink',
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
      'блгдр' => 'Thanksgiving',     # ко(лич)
      'блслв' => 'Benediction',      # от(стын)
      'брак' => 'Marriage',          # от(чел)-ко(чел)
      'вздв' => 'Exaltation',        # ч(стын)
      'вид' => 'Apparation',         # ч(стын)
      'вознс' => 'Ascension',        # ч(стын)
      'восст' => 'Restoration',      # к(чел)
      'вскрс' => 'Resurrection',     # к(чел)
      'дияк' => 'Deaconry',          # к(чел)
      'ересь' => 'Enheresment',      # к(чел)
      'застп' => 'Protection',       # от(стын) # покров
      'зач' => 'Conception',         # от(чел)-ко(чел)
      'знам' => 'Portent',           # ч(стын)
      'избав' => 'Deliverance',      # ч(стын)
      'иноч' => 'Monasticry',        # ко(чел)
      'ипод' => 'Hypodeaconry',      # ко(чел)
      'крещ' => 'Baptism',           # ко(чел)
      'надст' => 'Superstructure',   # ч(стын)
      'напис' => 'Writing',          # ч(обр)
      'нем' => 'Numbness',           # ко(чел)
      'низл' => 'Deposition',        # ко(чел)
      'обн' => 'Sanctification',     # ч(храм)
      'обнов' => 'Renewal',          # ч(обр)
      'обр' => 'Uncovering',         # ч(стын)
      'ожив' => 'Revival',           # от(чел)-ко(чел)
      'освоб' => 'Liberation',       # ко(чел)
      'ост' => 'Suspense',           # ч(стын)
      'отм' => 'Cancellation',       # ч(стын)
      'отр' => 'Renunciation',       # от(чел)
      'пгрб' => 'Burial',            # ко(чел)
      'покая' => 'Repentance',       # от(чел)
      'полож' => 'Placing',          # ч(стын)
      'почит' => 'Veneration',       # ч(стын)
      'прдст' => 'Primacy',          # от(чел)
      'прел' => 'PuttingInAgain',    # ч(стын)
      'прен' => 'Translation',       # ч(стын)
      'призв' => 'Calling',          # ко(чел)
      'вход' => 'Entrance',          # от(чел)
      'просл' => 'Canonization',     # от(чел)
      'прств' => 'Repose',           # от(чел)
      'прстл' => 'Throne',           # ч(храм)
      'разр' => 'Destruction',       # ч(храм)
      'раск' => 'Schism',            # от(чел)
      'распп' => 'Defrocking',       # ко(чел)
      'рассл' => 'Decanonization',   # от(чел)
      'ржд' => 'Nativity',           # от(чел)
      'рясф' => 'Frockbearing',      # ко(чел)
      'сбр' => 'Synaxis',            # ко(чел)
      'свят' => 'Bishopry',          # ко(чел)
      'свящ' => 'Priestship',        # ко(чел)
      'созд' => 'Founding',          # ч(храм)
      'сокр' => 'Hiddening',         # ч(стын)
      'сохр' => 'Keeping',           # ч(стын)
      'соявл' => 'Phenomenon',       # от(чел)-ко(чел)
      'срет' => 'Meeting',           # от(чел)-ко(чел)
      'стрст' => 'Passion',          # ко(чел)
      'схим' => 'Schima',            # ко(чел)
      'труд' => 'Labor',             # от(чел)
      'утр' => 'Loss',               # ч(стын)
      'чинпр' => 'Glorification',    # ко(чел)
      'чтец' => 'Reader',            # ко(чел)
      'чудо' => 'Miracle',           # ч(стын)
      'явл' => 'Appearance',         # ч(обр)
      'пожар' => 'GreatFire',        # ч(место)
      'тряс' => 'Earthquake',        # ч(место)
      'преоб' => 'Transfiguration',  # ко(чел)
      'изнес' => 'Procession',       # ч(стын)
      'вспом' => 'Commemoration',    # ч(предм)
      'похв' => 'Praise',            # ко(чел)
      'плен' => 'Captivity',         # ч(предм)
      'торжс' => 'Triumph',          # ч(предм)
      'покл' => 'Adoration',         # от(чел)-ко(чел)       # приношение, поклонение (волхвов)
      'обрез' => 'Circumcision',     # ко(чел)
      'введ' => 'BringIn',           # ко(чел)
      'плач' => 'Weeping',           # ко(чел)
      'откр' => 'Uncovering',        # ко(чел)
#      'общжр' => 'Massacre',         #
      'прок' => 'Curse',             # от(чел)
      'бесе' => 'Tale',              # от(чел)-ко(чел) # Беседа/Благовещение
      'изда' => 'Betraial',          # от(чел)-ко(чел)
      'пад' => 'Fall',               # ч(место)
      'науч' => 'Learning',          # от(чел)
      'покой' => 'Rest',             # от(чел)
      'тайн' => 'Supper',            # от(чел)
      'увер' => 'Assurance'          # от(чел)-ко(чел)
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
         when String
            result[key] = SUBPARSERS[ key ].constantize.parse
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
            [ result[ :happened_at ], ats ].transpose.map { |x| x.join(".") }
         end
      else
         ats.map { |x| "#{result[ :happened_at ]}.#{x}" }
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
            [ ats, result[ :happened_at ] ].transpose.map { |x| x.join(".") }
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
                  alphabeth_code: :ро,
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
      result[ :place ] = {
        descriptions: [ {
           alphabeth_code: :ро,
           language_code: :ру,
           text: value } ] }
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
