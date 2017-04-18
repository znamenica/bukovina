require 'uri'

class Bukovina::Parsers::Link
   attr_reader :errors

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse line
      # TODO skip return if errors found
      #
      res =
      case line
      when Hash
         links = line.map do |(lang, url)|
            if url.is_a?( Array )
               url.map do |u|
                  parse_line( u, lang ) ;end
               .compact
            else
               parse_line( url, lang ) ;end;end
         .compact.flatten
         { link: links }
      when Array
         links = line.map do |url|
            if url.is_a?( Array )
               url.map do |u|
                  parse_line( u ) ;end
               .compact
            else
               parse_line( url ) ;end;end
         .compact.flatten
         { link: links }
      when String
         { link: [ parse_line( line ) ] }
      when NilClass
      else
         @errors << Parsers::BukovinaInvalidClass.new( "Invalid class " +
            "#{line.class} for Name line '#{line}'" ) ; end

      @errors.empty? && res || nil ; end

   protected

   def valid? url, alphabeth_code
      uri = URI.parse( url )
      uri.kind_of?( URI::HTTP )
   rescue URI::InvalidURIError => e
      # URI::InvalidURIError: URI must be ascii only
      line = e.to_s.split('\u{').map do |tok|
         /^(?<num>[a-f0-9]+)/ =~ tok; num&.hex ; end
      .compact.pack("U*")

      line.size > 0 && ! Parsers::MATCH_TABLE[ alphabeth_code ] !~ line ; end

   def match_alphabeth? alphabeth_code, line
      filtered = line.gsub(/[0-9\s‑';:"«»,()\.\-\?\/]/,'')
      Parsers::MATCH_TABLE[ alphabeth_code ] =~ filtered ;end

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_line line, alphabeth_code = :ру
      alphabeth_code = alphabeth_code.to_sym

      language_codes = Language.language_list_for(alphabeth_code)
      if language_codes.present?
         if valid?( line, alphabeth_code )
            {  alphabeth_code: alphabeth_code,
               language_code: language_codes.first.to_sym,
               url: line }
         else
            @errors << Parsers::BukovinaInvalidUrlFormatError.new( "Invalid url" +
               " format for #{line}" )
            nil ;end
      else
         @errors << Parsers::BukovinaInvalidLanguageError.new( "Invalid " +
            "alphabeth '#{alphabeth_code}' specified" )
         nil ;end;end


   def initialize
      @errors = [] ; end ; end
