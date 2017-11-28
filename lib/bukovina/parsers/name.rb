class Bukovina::Parsers::Name
   attr_reader :errors

   Parsers = Bukovina::Parsers

   STATES = {
      'в наречении' => :наречёное,
      'в самонаречении' => :самоданное,
      'в крещении' => :крещенское,
      'в чернестве' => :чернецкое,
      'в рясофорстве' => :чернецкое,
      'в рясе' => :чернецкое,
      'в иночестве' => :иноческое,
      'в схиме' => :схимное,
      'в благословении' => :благословенное,
      'в покаянии' => :покаянное,
   }

#   RE = /(вид\.)?(#{STATES.keys.join('|')})?(?:\s*)([#{UPCHAR}][#{CHAR}\s][#{DOWNCHAR}]+)?(?:\s*([,()\/\-])\s*)?/
   RE = /(вид\.)?
         (#{STATES.keys.join('|').gsub(/\s+/,'\s')})?
         \s*
         ([#{Parsers::UPCHAR}][#{Parsers::CHAR}#{Parsers::ACCENT}\s‑]*)?
         (?:\s*([,()\/\-])\s*|\z)/x
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse name
      # TODO skip return if errors found
      #
      res =
      case name
      when Hash
         name_list = name.to_a.map do |(alphabeth_code, nameline)|
            if ! Parsers::MATCH_TABLE.has_key?( alphabeth_code.to_sym )
               raise Parsers::BukovinaInvalidLanguageError,
                  "Invalid alphabeth '#{alphabeth_code}' specified" ; end

            if nameline
               parse_line nameline, alphabeth_code
            else
               raise Parsers::BukovinaNullNameLine, "Null name line #{name.inspect}" +
                     " for the alphabeth #{alphabeth_code}" ; end ; end

         # remove enumerator error
         @errors.select! { |x| !x.is_a?( Parsers::BukovinaInvalidEnumeratorError ) }

         mn = name_list[0][ :memory_names ].select do |x|
            !x[ :name ].has_key?( :similar_to )
            end.map.with_index do |x, i|
            x[ :name ].has_key?( :text ) && x ||
               (sel = name_list[ 1..-1 ].select do |y|
                  y[ :memory_names ][ i ]&.[]( :name )&.has_key?( :text ) ; end
               sel.first&.[]( :memory_names )&.[]( i ) || x) ; end

         invalid_index = name_list[1..-1].any? do |ns|
            size = ns[ :memory_names ].reduce(0) do |s, x|
               x[ :name ].has_key?( :similar_to ) && s || s + 1 ; end
            size != mn.size ; end

         if invalid_index
            raise Parsers::BukovinaIndexError, "#{$!}: for name #{name}" ; end

         name_list[1..-1].each do |ns|
            ns[ :names ].each.with_index do |n, i|
               has_name =
               name_list[ 0 ][ :names ].select.with_index do |x, j|
                  j % name_list[ 0 ][ :memory_names ].size == i &&
                     x.has_key?( :text ) ; end

               if ! has_name.empty?
                  n[ :similar_to ] = has_name.first
               elsif mn[ i ] && mn[ i ][ :name ] != n
                  n[ :similar_to ] = mn[ i ][ :name ] ; end
               name_list[ 0 ][ :names ] << n ; end

            ns[ :memory_names ].each.with_index do |mn, i|
#            binding.pry
               if mn[ :name ].has_key?( :text )
                  if name_list[ 0 ][ :memory_names ][ i ].present?
                     if ! name_list[ 0 ][ :memory_names ][ i ][ :name ].has_key?( :text )
#            binding.pry
#                  Kernel.puts "*"*80
#                  Kernel.puts names[ 0 ].inspect
#                  Kernel.puts names[ 0 ][ :memory_names ].inspect
#                  Kernel.puts names[ 0 ][ :memory_names ][ i ].inspect
#                  Kernel.puts names[ 0 ][ :memory_names ][ i ]&.[]( :name ).inspect
#                  Kernel.puts names[ 0 ][ :memory_names ][ i ]&.[]( :name )&.has_key?( :text ).inspect
                        name_list[ 0 ][ :memory_names ][ i ][ :name ] = mn[ :name ] ;end
#                  else
#                     if 
#                     raise
                     ;end;end;end;end
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
         name_list[ 0 ][ :names ].delete_if { |n| !n[ :text ] }
         name_list[ 0 ][ :memory_names ].delete_if do |n|
            n[ :name ].has_key?( :similar_to ) ; end
         name_list[ 0 ]

      when String
         name_list = parse_line( name )
         name_list[ :names ]&.delete_if { |n| !n[ :text ] }
         name_list[ :memory_names ].delete_if { |n| n[ :name ].has_key?( :similar_to ) }
         name_list

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

   def parse_line line, alphabeth_code = 'ру'
      alphabeth_code = alphabeth_code.to_sym

      language_codes = Language.language_list_for(alphabeth_code)

      name = {
         type: 'FirstName',
         alphabeth_code: alphabeth_code,
         language_code: language_codes.first.to_sym }
      context = {
         alphabeth_code: alphabeth_code,
         language_code: language_codes.first.to_sym,
         models: { names: [ name ], memory_names: [ { name: name } ] } }

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
         context[ :models ][ :names ].last[ :text ] = token
         case context[ :mode ]
         when :prefix
            context[ :models ][ :memory_names ][ -2 ][ :mode ] = :prefix
         when :ored
            context[ :models ][ :memory_names ][ -2 ][ :mode ] = :ored
         when :alias
            prev = context[ :models ][ :names ][ 0..-2 ].select do |n|
               ! n.has_key?( :similar_to ) ; end.last
#            binding.pry
            context[ :models ][ :names ].last[ :similar_to ] = prev ; end ; end
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
      name = {
         type: 'FirstName',
         alphabeth_code: context[ :alphabeth_code ],
         language_code: context[ :language_code ] }
      context[ :models ][ :names ] << name
      memory_name = { name: name }
      if context[ :mode ] == :ored
         if context[ :models ][ :memory_names ].last[ :feasible ]
            memory_name[ :feasible ] =
            context[ :models ][ :memory_names ].last[ :feasible ] ; end
         if context[ :models ][ :memory_names ].last[ :state ]
            memory_name[ :state ] =
            context[ :models ][ :memory_names ].last[ :state ] ; end ; end
      context[ :models ][ :memory_names ] << memory_name ; end

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
         context[ :models ][ :memory_names ].last[ :feasible ] = true ; end ; end

   def apply_state state, context
      if state
         context[ :models ][ :memory_names ].last[ :state ] = STATES[ state ]
         end ; end

   def validate_token token, context
      matched =
      Parsers::MATCH_TABLE.to_a.reduce( nil ) do |s, (code, re)|
         if s
            next s; end

         if re =~ token&.gsub( /[\s‑]+/,'' )
#            binding.pry
            if context[ :models ][ :names ].last[ :alphabeth_code ] == code.to_sym
               token
#            else
#               raise BukovinaInvalidLanguage, "Invalid language '"            \
#                  "#{context[ :models ][ :names ].last[ :language_code ]}' "   \
#                  "for the #token '#{token}'" ;
               end ; end ; end

      if token && ! matched
#         binding.pry
         raise Parsers::BukovinaInvalidCharError, "Invalid char(s) for alphabeth '" +
            "#{context[ :models ][ :names ].last[ :alphabeth_code ]}' specified" ; end
            
      matched

   rescue Parsers::BukovinaError => e
      @errors << e
      nil ; end

   def initialize
      @errors = [] ; end ; end

