class Bukovina::Parsers::Service
   attr_reader :errors

   Parsers = Bukovina::Parsers

   VALID_KEYS = [
      :вечерня,
      :отпустительно,
      :тропарь,
      :глас,
      :подобен,
      :текст,
      :молитва,
      :утреня,
      :кафисма,
      :седален,
      :величание,
      :канон,
      :кондак,
      :икос,
   ]

   def parse line
      res =
      if line.is_a?( Hash )
         parse_hash( line )
      else
         @errors << Parsers::BukovinaInvalidClass.new( "Invalid class " +
            "#{line.class} for Name line '#{line}'" ) ; end

      @errors.empty? && res || nil ; end

   private

   def validate_key key
      if ! VALID_KEYS.include?( key )
         @errors << Parsers::BukovinaInvalidKeyName.new( "Invalid key " +
            "#{key.inspect} for hash" ) ; end

      true ; end

   def parse_value value
      case value
      when Integer, String
         value
      when Array
         value.map { |x| parse_value( x ) }
      when Hash
         parse_hash( value )
      else
         @errors << Parsers::BukovinaInvalidValue.new( "Invalid key " +
            "#{value.inspect} for hash" ) ; end ; end

   def parse_hash hash
      hash.map do |(key, value)|
         case key
         when String
            newkey = key.to_sym
            if ! validate_key( newkey )
               next ; end
            [ newkey, parse_value( value ) ]
         when Symbol
            if validate_key( key )
               [ key, parse_value( value ) ] ; end
         else
            @errors << Parsers::BukovinaInvalidKeyFormat.new( "Invalid key " +
               "#{key.inspect} for hash" ) ; end
      end.compact.map { |(k,v)| v && [ k, v ] || nil }.compact.to_h ; end

   def initialize
      @errors = [] ; end ; end
