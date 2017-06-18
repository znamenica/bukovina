class Bukovina::Parsers::Patronymic
   attr_reader :errors

   Parsers = Bukovina::Parsers

   STATES = {
      'по отцу' => :отчество,
      'по куму' => :кумство,
      'в принятии' => :отчество_принятое,
   }

   RE = /(вид\.)?
         (#{STATES.keys.join('|').gsub(/\s+/,'\s')})?
         \s*
         ([#{Parsers::UPCHAR}][#{Parsers::CHAR}#{Parsers::ACCENT}]*)?
         (?:\s*([,()\/\-])\s*|\z)/x
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse name
      # TODO skip return if errors found
      #
      res =
      case name
      when Hash
         names = name.to_a.map do |(alphabeth_code, nameline)|
            if ! Parsers::MATCH_TABLE.has_key?( alphabeth_code.to_sym )
               raise Parsers::BukovinaInvalidLanguageError,
                  "Invalid alphabeth '#{alphabeth_code}' specified" ; end

            if nameline
               parse_line nameline, alphabeth_code
            else
               raise Parsers::BukovinaNullNameLine, "Null name line #{name.inspect}" +
                     " for the alphabeth #{alphabeth_code}" ; end ; end

         # remove enumerator error
         @errors.select! do |x|
            !x.is_a?( Parsers::BukovinaInvalidEnumeratorError ) ; end

         mn = names[0][ :memory_names ].select do |x|
            !x[ :name ].has_key?( :similar_to )
            end.map.with_index do |x, i|
            x[ :name ].has_key?( :text ) && x ||
               (sel = names[ 1..-1 ].select do |y|
                  y[ :memory_names ][ i ]&.[]( :name )&.has_key?( :text ) ; end
               sel.first&.[]( :memory_names )&.[]( i ) || x) ; end

         invalid_index = names[1..-1].any? do |ns|
            size = ns[ :memory_names ].reduce(0) do |s, x|
               x[ :name ].has_key?( :similar_to ) && s || s + 1 ; end
            size != mn.size ; end

         if invalid_index
            raise Parsers::BukovinaIndexError, "#{$!}: for name #{name}" ; end

         names[1..-1].each do |ns|
            ns[ :names ].each.with_index do |n, i|
               has_name =
               names[ 0 ][ :names ].select.with_index do |x, j|
                  j % names[ 0 ][ :memory_names ].size == i &&
                     x.has_key?( :text ) ; end

               if ! has_name.empty?
                  n[ :similar_to ] = has_name.first
               elsif mn[ i ] && mn[ i ][ :names ] != n
                  n[ :similar_to ] = mn[ i ][ :names ] ; end
               names[ 0 ][ :names ] << n ; end

            ns[ :memory_names ].each.with_index do |mn, i|
               if mn[ :name ].has_key?( :text )
                  if names[ 0 ][ :memory_names ][ i ].present?
                     if ! names[ 0 ][ :memory_names ][ i ][ :name ].has_key?( :text )
                        names[ 0 ][ :memory_names ][ i ][ :name ] = mn[ :name ] ;end
                     ;end;end;end;end

         names[ 0 ][ :names ].delete_if { |n| !n[ :text ] }
         names[ 0 ][ :memory_names ].delete_if do |n|
            n[ :name ].has_key?( :similar_to ) ; end
         names[ 0 ]

      when String
         names = parse_line( name )
         names[ :names ]&.delete_if { |n| !n[ :text ] }
         names[ :memory_names ].delete_if { |n| n[ :name ].has_key?( :similar_to ) }
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

   def parse_line line, alphabeth_code = 'ру'
      alphabeth_code = alphabeth_code.to_sym

      language_codes = Language.language_list_for(alphabeth_code)

      name = {
         type: 'Patronymic',
         alphabeth_code: alphabeth_code,
         language_code: language_codes.first.to_sym }
      context = {
         alphabeth_code: alphabeth_code,
         language_code: language_codes.first.to_sym,
         models: { names: [ name ], memory_names: [ { name: name } ] } }

      while ! line.empty? do
         match = RE.match( line )

#        binding.pry
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
#     binding.pry

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
            context[ :models ][ :names ].last[ :similar_to ] = prev ; end ; end

   rescue Parsers::BukovinaError => e
      @errors << e ; end

   def new_record context
      name = {
         type: 'Patronymic',
         alphabeth_code: context[ :alphabeth_code ],
         language_code: context[ :language_code ] }
      context[ :models ][ :names ] << name
      memory_name = { name: name }
      if context[ :mode ] == :ored
         if context[ :models ][ :memory_names ].last[ :feasibly ]
            memory_name[ :feasibly ] =
            context[ :models ][ :memory_names ].last[ :feasibly ] ; end
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
         context[ :models ][ :memory_names ].last[ :feasibly ] = :feasible
         end ; end

   def apply_state state, context
      context[ :models ][ :memory_names ].last[ :state ] =
      STATES[ state ] || :отчество ; end

   def validate_token token, context
      matched =
      Parsers::MATCH_TABLE.to_a.reduce( nil ) do |s, (code, re)|
         if s
            next s; end

         if re =~ token
            if context[ :models ][ :names ].last[ :alphabeth_code ] == code.to_sym
               token
               end ; end ; end

      if token && ! matched
         raise Parsers::BukovinaInvalidCharError, "Invalid char(s) for alphabeth '" +
            "#{context[ :models ][ :names ].last[ :alphabeth_code ]}' specified" ; end
            
      matched

   rescue Parsers::BukovinaError => e
      @errors << e
      nil ; end

   def initialize
      @errors = [] ; end ; end

