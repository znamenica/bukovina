class Bukovina::Parsers::Name
   attr_reader :errors

   Parsers = Bukovina::Parsers

   STATES = {
      'в наречении' => :наречёное,
      'в крещении' => :крещенское,
      'в чернестве' => :чернецкое,
      'в иночестве' => :иноческое,
      'в схиме' => :схимное,
   }

#   RE = /(вид\.)?(#{STATES.keys.join('|')})?(?:\s*)([#{UPCHAR}][#{CHAR}\s][#{DOWNCHAR}]+)?(?:\s*([,()\/\-])\s*)?/
   RE = /(вид\.)?
         (#{STATES.keys.join('|').gsub(/\s+/,'\s')})?
         \s*
         ([#{Parsers::UPCHAR}][#{Parsers::CHAR}#{Parsers::ACCENT}\s]*)?
         (?:\s*([,()\/\-])\s*|\z)/x
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse name
      # TODO skip return if errors found
      #
      res =
      case name
      when Hash
         names = name.to_a.map do |(language_code, nameline)|
            if ! Parsers::MATCH_TABLE.has_key?( language_code.to_sym )
               raise Parsers::BukovinaInvalidLanguageError, "Invalid language '"
                  "#{language_code}' specified" ; end

            if nameline
               parse_line nameline, language_code
            else
               raise Parsers::BukovinaNullNameLine, "Null name line #{name.inspect}"
                     " for the language #{language_code}" ; end ; end

         # remove enumerator error
         @errors.select! { |x| !x.is_a?( Parsers::BukovinaInvalidEnumeratorError ) }

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
            raise Parsers::BukovinaIndexError, "#{$!}: for name #{name}" ; end

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
         raise Parsers::BukovinaInvalidClass, "Invalid class #{name.class} " +
               "for Name line '#{name}'" ; end

      @errors.empty? && res || nil

   rescue Parsers::BukovinaError => e
      @errors << e
      nil ; end

private

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_error line
      error =
      if line !~ /\A\s*,\s*$\z/
         Parsers::BukovinaFalseSyntaxError.new( line ) ; end
      @errors << error ; end

   def parse_line line, language_code = 'ру'
      name = { language_code: language_code.to_sym }
      context = {
         language_code: language_code.to_sym,
         models: { name: [ name ], memory_name: [ { name: name } ] } }

      while ! line.empty? do
         match = RE.match( line )

#         binding.pry
         if ! match
            parse_error( line )
            match = [ nil, nil, nil, nil, line ] ; end
         if match.is_a?( MatchData ) && match.begin( 0 ) > 0
            parse_error( line[ 0...match.begin( 0 ) ] ) ; end

         apply_pref( match[ 1 ], context )
         apply_state( match[ 2 ], context )
         apply_token( validate_token( match[ 3 ]&.strip, context ), context )
         apply_separator( match[ 3 ], match[ 4 ]&.strip, context )
         line = line[ match.end( 0 )..-1 ] ; end
#      binding.pry

      context[ :models ]

   rescue Parsers::BukovinaError => e
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

   rescue Parsers::BukovinaError => e
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
            @errors << Parsers::BukovinaInvalidEnumeratorError.new(
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
      Parsers::MATCH_TABLE.to_a.reduce( nil ) do |s, (code, re)|
         if s
            next s; end

         if re =~ token&.gsub( /\s+/,'' )
#            binding.pry
            if context[ :models ][ :name ].last[ :language_code ] == code.to_sym
               token
#            else
#               raise BukovinaInvalidLanguage, "Invalid language '"            \
#                  "#{context[ :models ][ :name ].last[ :language_code ]}' "   \
#                  "for the #token '#{token}'" ;
               end ; end ; end

      if token && ! matched
#         binding.pry
         raise Parsers::BukovinaInvalidCharError, "Invalid char(s) for language '"
            "#{context[ :attr ].last[ :language_code ]}' specified" ; end
            
      matched

   rescue Parsers::BukovinaError => e
      @errors << e
      nil ; end

   def initialize
      @errors = [] ; end ; end

