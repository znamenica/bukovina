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
                  parse_line( u, lang ) ; end.compact
            else
               parse_line( url, lang ) ; end ; end
         .compact.flatten
         { link: links }
      when Array
         links = line.map do |url|
            if url.is_a?( Array )
               url.map do |u|
                  parse_line( u ) ; end.compact
            else
               parse_line( url ) ; end ; end
         .compact.flatten
         { link: links }
      when String
         { link: [ parse_line( line ) ] }
      when NilClass
      else
         @errors << Parsers::BukovinaInvalidClass.new( "Invalid class " +
            "#{line.class} for Name line '#{line}'" ) ; end

      @errors.empty? && res || nil ; end

   private

   def valid? url, language_code
      uri = URI.parse( url )
      uri.kind_of?( URI::HTTP )
   rescue URI::InvalidURIError => e
      # URI::InvalidURIError: URI must be ascii only
      line = e.to_s.split('\u{').map do |tok|
         /^(?<num>[a-f0-9]+)/ =~ tok; num&.hex ; end
      .compact.pack("U*")

      line.size > 0 && ! Parsers::MATCH_TABLE[ language_code ] !~ line ; end

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_line line, language_code = 'ру'
      language_code = language_code.to_sym

      if ! Parsers::MATCH_TABLE[ language_code ]
         @errors << Parsers::BukovinaInvalidLanguageError.new( "Invalid " +
            "language '#{language_code}' specified" )
         return nil

      elsif ! valid?( line, language_code )
         @errors << Parsers::BukovinaInvalidUrlFormatError.new( "Invalid url" +
            " format for #{line}" )
         nil

      else
         { language_code: language_code, url: line } ; end ; end

   def initialize
      @errors = [] ; end ; end
