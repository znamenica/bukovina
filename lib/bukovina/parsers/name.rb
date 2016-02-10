class Bukovina::Parsers::Name
   attr_reader :errors

   class BukovinaError < StandardError; end
   class BukovinaTypeError < BukovinaError; end
   class BukovinaIndexError < BukovinaError; end
   class BukovinaInvalidClass < BukovinaError; end
   class BukovinaInvalidLanguageError < BukovinaError; end
   class BukovinaInvalidContext < BukovinaError; end
   class BukovinaInvalidCharError < BukovinaError; end
   class BukovinaInvalidTokenError < BukovinaError; end
   class BukovinaInvalidEnumeratorError < BukovinaError; end
   class BukovinaInvalidVariatorError < BukovinaError; end
   class BukovinaEmptyRecord < BukovinaError; end
   class BukovinaNullNameLine < BukovinaError; end

   STATES = {
      'в наречении' => :наречёное,
      'в крещении' => :крещенское,
      'в чернестве' => :чернецкое,
      'в иночестве' => :иноческое,
      'в схиме' => :схимное,
   }

   # TODO добавить проверку регвыра в проверяльщик модели
   RUSSIAN_CAPITAL = 'А-ЯЁ'
   RUSSIAN_STROKE = 'а-яё'
   RUSSIAN_ACCENT = '́'
   CSLAV_CAPITAL = 'А-ЬЮЅІѠѢѦѮѰѲѴѶѸѺѼѾꙖꙊ'
   CSLAV_STROKE = 'а-ьюєѕіѡѣѧѯѱѳѵѷѹѻѽѿꙗꙋ'
   CSLAV_ACCENT = '̀́̓̔҃҇҈҉꙽'
   SERBIAN_CAPITAL = 'ЂЈ-ЋЏА-ИК-Ш'
   SERBIAN_STROKE = 'ђј-ћа-ик-ш'
   GREEK_CAPITAL = 'ͶͲΑ-ΫϏϒϓϔϘϚϜϠϞϴϷϹϺϾϿἈ-ἏἘ-ἝἨ-ἯἸ-ἿὈ-ὍὙ-ὟὨ-Ὧᾈ-ᾏᾘ-ᾟᾨ-ᾯᾸ-ᾼῈ-ῌῘ-ΊῨ-ῬῸ-ῼΩΆ-Ώ'
   GREEK_STROKE = 'ά-ώϐϑϕ-ϗϙϛϝ-ϟϡ-ϳϵ-϶ϸϻϼᴦ-ᴪἀ-ἇἐ-ἕἠ-ἧἰ-ἷὀ-ὅὐ-ὗὠ-ὧὰ-ᾇᾐ-ᾗᾠ-ᾧᾰ-ᾷῂ-ῇῐ-ῗῠ-ῧῲ-ῷͻ-ͽͷΐά-ΰ'
   GREEK_ACCENT = 'ͺ͵΄᾽ι᾿῀῁῍῎῏῝῞῟῭΅`´῾'
   BULGARIAN_CAPITAL = 'А-ЪЬЮЯ'
   BULGARIAN_STROKE = 'а-ъьюя'
   LATIN_CAPITAL = 'A-IK-TVX-ZÆ'
   LATIN_STROKE = 'a-ik-tvx-zæ'
   IRISH_CAPITAL = 'A-IL-PR-U'
   IRISH_STROKE = 'a-il-pr-u'
   CZECH_CAPITAL = 'A-PR-VX-ZÁÉĚÍÓÚŮÝČĎŇŘŠŤŽ'
   CZECH_STROKE = 'a-pr-vx-záéěíóúůýčďňřšťž'
   CZECH_ACCENT = '́̌̊'
   ENGLISH_CAPITAL = 'A-Z'
   ENGLISH_STROKE = 'a-z'
   ITALIAN_CAPITAL = 'A-IL-VZ'
   ITALIAN_STROKE = 'a-il-vz'
   ARMENIAN_CAPITAL = 'Ա-Ֆ'
   ARMENIAN_STROKE = 'ա-և'
   IVERIAN_STROKE = 'ა-ჺჽ'
   ROMANIAN_CAPITAL = 'A-ZĂÂÎȘȚ'
   ROMANIAN_STROKE = 'a-zăâîșț'
   OLD_ENGLISH_CAPITAL = 'A-IL-PR-UW-YÆÐꝽÞǷĊĠĀĒĪŌŪ'
   OLD_ENGLISH_STROKE = 'a-il-pr-uw-yæðᵹſþƿċġāēīūō'

   UPCHAR = RUSSIAN_CAPITAL + CSLAV_CAPITAL + SERBIAN_CAPITAL + GREEK_CAPITAL +
      ENGLISH_CAPITAL + LATIN_CAPITAL + CZECH_CAPITAL + ARMENIAN_CAPITAL +
      ROMANIAN_CAPITAL + OLD_ENGLISH_CAPITAL
   DOWNCHAR = RUSSIAN_STROKE + CSLAV_STROKE + SERBIAN_STROKE + GREEK_STROKE +
      ENGLISH_STROKE + LATIN_STROKE + CZECH_STROKE + ARMENIAN_STROKE +
      IVERIAN_STROKE + ROMANIAN_STROKE + OLD_ENGLISH_STROKE
   ACCENT = GREEK_ACCENT + RUSSIAN_ACCENT + CSLAV_ACCENT
   CHAR = DOWNCHAR + UPCHAR

   MATCH_TABLE = {
      :ру => /^[#{RUSSIAN_CAPITAL}#{RUSSIAN_STROKE}#{RUSSIAN_ACCENT}][#{RUSSIAN_STROKE}#{RUSSIAN_ACCENT}]*$/,
      :цс => /^[#{CSLAV_CAPITAL}#{CSLAV_STROKE}#{CSLAV_ACCENT}][#{CSLAV_STROKE}#{CSLAV_ACCENT}]*$/,
      :ср => /^[#{SERBIAN_CAPITAL}#{SERBIAN_STROKE}][#{SERBIAN_STROKE}]*$/,
      :гр => /^[#{GREEK_CAPITAL}#{GREEK_STROKE}#{GREEK_ACCENT}][#{GREEK_STROKE}#{GREEK_ACCENT}]*$/,
      :ан => /^[#{ENGLISH_CAPITAL}#{ENGLISH_STROKE}][#{ENGLISH_STROKE}]*$/,
      :чх => /^[#{CZECH_CAPITAL}#{CZECH_STROKE}#{CZECH_ACCENT}][#{CZECH_STROKE}#{CZECH_ACCENT}]*$/,
      :ир => /^[#{IRISH_CAPITAL}#{IRISH_STROKE}][#{IRISH_STROKE}]*$/,
      :си => /^[#{IRISH_CAPITAL}#{IRISH_STROKE}][#{IRISH_STROKE}]*$/,
      :ла => /^[#{LATIN_CAPITAL}#{LATIN_STROKE}][#{LATIN_STROKE}]*$/,
      :бг => /^[#{BULGARIAN_CAPITAL}#{BULGARIAN_STROKE}][#{BULGARIAN_STROKE}]*$/,
      :ит => /^[#{ITALIAN_CAPITAL}#{ITALIAN_STROKE}][#{ITALIAN_STROKE}]*$/,
      :ар => /^[#{ARMENIAN_CAPITAL}#{ARMENIAN_STROKE}][#{ARMENIAN_STROKE}]*$/,
      :ив => /^[#{IVERIAN_STROKE}]+$/,
      :рм => /^[#{ROMANIAN_CAPITAL}#{ROMANIAN_STROKE}][#{ROMANIAN_STROKE}]*$/,
      :са => /^[#{OLD_ENGLISH_CAPITAL}#{OLD_ENGLISH_STROKE}][#{OLD_ENGLISH_STROKE}]*$/
   }

#   RE = /(вид\.)?(#{STATES.keys.join('|')})?(?:\s*)([#{UPCHAR}][#{CHAR}\s][#{DOWNCHAR}]+)?(?:\s*([,()\/\-])\s*)?/
   RE = /(вид\.)?(#{STATES.keys.join('|')})?(?:\s*)([#{CHAR}][#{DOWNCHAR}#{ACCENT}]*)?(?:\s*([,()\/\-])\s*)?/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse name
      # TODO skip return if errors found
      #
      res =
      case name
      when Hash
         names = name.to_a.map do |(language_code, nameline)|
            if ! MATCH_TABLE.has_key?( language_code.to_sym )
               raise BukovinaInvalidLanguageError, "Invalid language '"
                  "#{language_code}' specified" ; end

            if nameline
               parse_line nameline, language_code
            else
               raise BukovinaNullNameLine, "Null name line #{name.inspect}"
                     " for the language #{language_code}" ; end ; end

         # remove enumerator error
         @errors.select! { |x| !x.is_a?( BukovinaInvalidEnumeratorError ) }

         mn = names[0][ :memory_name ].select do |x|
            !x[ :name ].has_key?( :similar_to )
            end.map.with_index do |x, i|
            x[ :name ].has_key?( :text ) && x ||
               (sel = names[ 1..-1 ].select do |y|
                  y[ :memory_name ][ i ]&.[]( :name )&.has_key?( :text ) ; end
               sel.first&.[]( :memory_name )&.[]( i ) || x) ; end

         invalid_index = names[1..-1].any? do |ns|
            size = ns[ :memory_name ].reduce(0) do |s, x|
               x[ :name ].has_key?( :similar_to ) && s || s + 1 ; end
            size != mn.size ; end

         if invalid_index
            raise BukovinaIndexError, "#{$!}: for name #{name}" ; end

         names[1..-1].each do |ns|
            ns[ :name ].each.with_index do |n, i|
               has_name =
               names[ 0 ][ :name ].select.with_index do |x, j|
                  j % names[ 0 ][ :memory_name ].size == i &&
                     x.has_key?( :text ) ; end

#               binding.pry
               if ! has_name.empty?
                  n[ :similar_to ] = has_name.first
               elsif mn[ i ] && mn[ i ][ :name ] != n
                  n[ :similar_to ] = mn[ i ][ :name ] ; end
               names[ 0 ][ :name ] << n ; end

            ns[ :memory_name ].each.with_index do |mn, i|
               if mn[ :name ].has_key?( :text ) &&
                  ! names[ 0 ][ :memory_name ][ i ]&.[]( :name )&.has_key?( :text )
                  names[ 0 ][ :memory_name ][ i ][ :name ] = mn[ :name ]
                  end ; end ; end
#         binding.pry
#         rescue TypeError
#            raise BukovinaTypeError, "#{$!}: for name #{name}"
=begin

         names.each do |name_dup|
            dupes = name_dup.map { |n| n[ :text ] }.compact
            name_dup.each do |name|
               name[ :dupes ] = dupes - [ name[ :text] ] ; end ; end

         # detect empty text names
         empty = names.any? { |name_dup| name_dup.all? { |n| n[ :text ] } }
         if empty
            raise BukovinaEmptyRecord, "Empty record found for the names "
                  "hash: #{name.inspect}" ; end
=end
         names[ 0 ][ :name ].delete_if { |n| !n[ :text ] }
         names[ 0 ][ :memory_name ].delete_if { |n| n[ :name ].has_key?( :similar_to ) }
#         binding.pry
         names[ 0 ]
      when String
         names = parse_line( name )
         names[ :name ]&.delete_if { |n| !n[ :text ] }
         names[ :memory_name ].delete_if { |n| n[ :name ].has_key?( :similar_to ) }
#         binding.pry
         names
      when NilClass
      else
         raise BukovinaInvalidClass, "Invalid class #{name.class} " +
               "for Name line '#{name}'" ; end

      @errors.empty? && res || nil

   rescue BukovinaError => e
      @errors << e
      nil ; end

private

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_line nameline, language_code = 'ру'
      name = { language_code: language_code.to_sym }
      context = {
         language_code: language_code.to_sym,
         models: { name: [ name ], memory_name: [ { name: name } ] } }

      nameline.scan( RE ) do |(pref, state, token, sepa)|
         apply_pref( pref, context )
         apply_state( state, context )
         apply_token( validate_token( token, context ), context )
         apply_separator( token, sepa&.strip, context ) ; end
#      binding.pry

      context[ :models ]

   rescue BukovinaError => e
      @errors << e
      {}; end

   def apply_token token, context
      if token
         context[ :models ][ :name ].last[ :text ] = token
         case context[ :mode ]
         when :prefix
            context[ :models ][ :memory_name ][ -2 ][ :mode ] = :prefix
         when :ored
            context[ :models ][ :memory_name ][ -2 ][ :mode ] = :ored
         when :alias
            prev = context[ :models ][ :name ][ 0..-2 ].select do |n|
               ! n.has_key?( :similar_to ) ; end.last
#            binding.pry
            context[ :models ][ :name ].last[ :similar_to ] = prev ; end ; end
#      else
#         aliases = context.delete( :aliases )
#         dup = aliases.dup
#         i = -1
#         dup.each do |name|
#            context[ :attrs ][ i ][ :aliases ] = aliases - [ name ]
#            dup.delete( name )
#            i -= -1 ; end

#            if aliases.nil?
#               raise BukovinaInvalidContext, "Invalid context "
#                     "'#{context[ :mode ]}' for token #{token}"
#               end ; end

#         if token[ 0 ].capitalize != token[ 0 ]
#            @errors << "Invalid token '#{token}' for language "
#                       "'#{context[ :attrs].last[ :language_code]}'" ; end

   rescue BukovinaError => e
      @errors << e ; end

   def new_record context
      name = { language_code: context[ :language_code ] }
      context[ :models ][ :name ] << name
      memory_name = { name: name }
      if context[ :mode ] == :ored
         if context[ :models ][ :memory_name ].last[ :feasibly ]
            memory_name[ :feasibly ] =
            context[ :models ][ :memory_name ].last[ :feasibly ] ; end
         if context[ :models ][ :memory_name ].last[ :state ]
            memory_name[ :state ] =
            context[ :models ][ :memory_name ].last[ :state ] ; end ; end
      context[ :models ][ :memory_name ] << memory_name ; end

   def apply_separator token, sepa, context
      case sepa
      when ','
         if !token && context[ :mode ] != :stop_alias
            @errors << BukovinaInvalidEnumeratorError.new(
               "Invalid enumerator ',' token" ) ; end
         if context[ :mode ] == :alias
            context[ :mode ] ||= :next
         else
            context[ :mode ] = :next ; end
         new_record( context )
      when '('
         context[ :mode ] = :alias
         new_record( context )
      when ')'
         context[ :mode ] = :stop_alias
      when '/'
         context[ :mode ] = :ored
         new_record( context )
      when '-'
         context[ :mode ] = :prefix
         new_record( context )
      when nil ; end ; end

   def apply_pref pref, context
      if pref
         context[ :models ][ :memory_name ].last[ :feasibly ] = :feasible ; end ; end

   def apply_state state, context
      if state
         context[ :models ][ :memory_name ].last[ :state ] = STATES[ state ]
         end ; end

   def validate_token token, context
      matched =
      MATCH_TABLE.to_a.reduce( nil ) do |s, (code, re)|
         if s
            next s; end

         if re =~ token
#            binding.pry
            if context[ :models ][ :name ].last[ :language_code ] == code.to_sym
               token
#            else
#               raise BukovinaInvalidLanguage, "Invalid language '"            \
#                  "#{context[ :models ][ :name ].last[ :language_code ]}' "   \
#                  "for the #token '#{token}'" ;
               end ; end ; end

#      binding.pry
      if token && ! matched
         raise BukovinaInvalidCharError, "Invalid char(s) for language '"
            "#{context[ :attr ].last[ :language_code ]}' specified" ; end
            
      matched

   rescue BukovinaError => e
      @errors << e
      nil ; end

   def initialize
      @errors = [] ; end ; end

