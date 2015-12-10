class Bukovina::Parsers::Name
   attr_reader :errors

   class BukovinaError < StandardError; end
   class BukovinaTypeError < BukovinaError; end
   class BukovinaIndexError < BukovinaError; end
   class BukovinaInvalidClass < BukovinaError; end
   class BukovinaInvalidLanguage < BukovinaError; end
   class BukovinaInvalidContext < BukovinaError; end
   class BukovinaEmptyRecord < BukovinaError; end
   class BukovinaNullNameLine < BukovinaError; end

   STATES = {
      'в наречении' => :наречёное,
      'в крещении' => :крещенское,
      'в иночестве' => :иноческое,
      'в схиме' => :схимное,
   }

   RUSSIAN_CAPITAL = 'А-ЯЁ'
   RUSSIAN_STROKE = 'а-яё'
   SERBIAN_CAPITAL = 'ЂЈ-ЋЏА-ИК-Ш'
   SERBIAN_STROKE = 'ђј-ћа-ик-ш'
   GREEK_CAPITAL = 'ͶͲΑ-ΫϏϒϓϔϘϚϜϠϞϴϷϹϺϾϿἈ-ἏἘ-ἝἨ-ἯἸ-ἿὈ-ὍὙ-ὟὨ-Ὧᾈ-ᾏᾘ-ᾟᾨ-ᾯᾸ-ᾼῈ-ῌῘ-ΊῨ-ῬῸ-ῼΩ'
   GREEK_STROKE = 'ά-ώϐϑϕ-ϗϙϛϝ-ϟϡ-ϳϵ-϶ϸϻϼᴦ-ᴪἀ-ἇἐ-ἕἠ-ἧἰ-ἷὀ-ὅὐ-ὗὠ-ὧὰ-ᾇᾐ-ᾗᾠ-ᾧᾰ-ᾷῂ-ῇῐ-ῗῠ-ῧῲ-ῷͻ-ͽͷ'
   GREEK_ACCENT = 'ͺ͵΄᾽ι᾿῀῁῍῎῏῝῞῟῭΅`´῾'

   UPCHAR = RUSSIAN_CAPITAL + SERBIAN_CAPITAL + GREEK_CAPITAL + GREEK_ACCENT
   DOWNCHAR = RUSSIAN_STROKE + SERBIAN_STROKE + GREEK_STROKE + GREEK_ACCENT
   CHAR = DOWNCHAR + UPCHAR

   MATCH_TABLE = {
      :ру => /^[#{RUSSIAN_CAPITAL}#{RUSSIAN_STROKE}][#{RUSSIAN_STROKE}]*$/,
      :ср => /^[#{SERBIAN_CAPITAL}#{SERBIAN_STROKE}][#{SERBIAN_STROKE}]*$/,
      :гр => /^[#{GREEK_CAPITAL}#{GREEK_STROKE}#{GREEK_ACCENT}][#{GREEK_STROKE}#{GREEK_ACCENT}]*$/, }

   RE = /#{STATES.keys.join('|')}|вид\.|[#{UPCHAR}][#{CHAR}\s][#{DOWNCHAR}](\s*[,()])?/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse name
      # TODO skip return if errors found
      #
      case name
      when Hash
         names = name.to_a.map do |(language_code, nameline)|
            if nameline
               parse_line nameline, language_code
            else
               raise BukovinaNullNameLine, "Null name line #{name.inspect}"
                     " for the language #{language_code}" ; end ; end

         names =
         begin
            binding.pry
            names.transpose
         rescue TypeError
            raise BukovinaTypeError, "#{$!}: for name #{name}"
         rescue IndexError
            raise BukovinaIndexError, "#{$!}: for name #{name}" ; end

         names.each do |name_dup|
            dupes = name_dup.map { |n| n[ :text ] }.compact
            name_dup.each do |name|
               name[ :dupes ] = dupes - [ name[ :text] ] ; end ; end

         # detect empty text names
         empty = names.any? { |name_dup| name_dup.all? { |n| n[ :text ] } }
         if empty
            raise BukovinaEmptyRecord, "Empty record found for the names "
                  "hash: #{name.inspect}" ; end
         names
      when String
         parse_line name
      when NilClass
      else
         raise BukovinaInvalidClass, "Invalid class #{name.class} "
               "for Name line '#{name}'" ; end

   rescue BukovinaError => e
      @errors << e
      {} ; end

private

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_line nameline, language_code = :ру
      language_code = language_code.to_sym
      context = { attrs: [] }
      nameline.scan( RE ) do |token|
         context[ :attrs ] << {
            language_code: language_code,
         }

         apply_separator sepa.strip, context
         parse_token token, context ; end

      context[ :attrs ]

   rescue BukovinaError => e
      @errors << e
      {}; end

   def apply_token context
      token = ( context.delete( :tokens ) || [] ).join(' ')
      case token
      when /#{STATES.keys.join('|')}/
         context[ :attrs ].last[ :state ] = STATES[ token ]
      else
         context[ :attrs ].last[ :text ] = token
         case context[ :mode ]
         when :next
         when :alias
            context[ :aliases ] << token
         else
            aliases = context.delete( :aliases )
            dup = aliases.dup
            i = -1
            dup.each do |name|
               context[ :attrs ][ i ][ :aliases ] = aliases - [ name ]
               dup.delete( name )
               i -= -1 ; end

            if aliases.nil?
               raise BukovinaInvalidContext, "Invalid context "
                     "'#{context[ :mode ]}' for token #{token}"
               end ; end

         if token[ 0 ].capitalize != token[ 0 ]
            @errors << "Invalid token '#{token}' for language "
                       "'#{context[ :attrs].last[ :language_code]}'" ; end ; end

   rescue BukovinaError => e
      @errors << e
      {} ; end

   def apply_separator token, sepa, context
      case sepa
      when ','
         context[ :mode ] ||= :next
      when '('
         context[ :mode ] = :alias
         context[ :aliases ] = []
      when ')'
         context.delete( :mode ) ; end
   end

   def parse_token token, context
#            binding.pry
      if token == 'вид.' #NOTE may be erroneouse
         context[ :attrs ].last[ :feasibly ] = true
      else
         matched =
         MATCH_TABLE.to_a.reduce(nil) do |s, (code, re)|
            if s
               next s; end

            if re =~ token
               if context[ :attrs ].last[ :language_code ] == code
                  token
               else
                  raise BukovinaInvalidLanguage, "Invalid language '"
                        "#{context[ :attr].last[ :language_code]}' for the "
                        "#token '#{token}'"
                  nil ; end ; end ; end

         if matched
            context [ :tokens ] ||= []
            context [ :tokens ] << matched
         else
            raise BukovinaInvalidLanguage, "Invalid language '"
                  "#{context[ :attr].last[ :language_code]}' specified"
            end ; end

   rescue BukovinaError => e
      @errors << e
      {} ; end

   def initialize
      @errors = [] ; end ; end

