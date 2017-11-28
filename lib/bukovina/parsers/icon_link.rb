require 'uri'

class Bukovina::Parsers::IconLink
   attr_reader :errors

   Parsers = Bukovina::Parsers

   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse line
      # TODO skip return if errors found
      #
      res =
      case line
      when Array
         links = line.map do |url|
            if url.is_a?( Array )
               url.map do |u|
                  parse_line( u ) ; end.compact
            else
               parse_line( url ) ; end ; end
         .compact.flatten
         { icon_link: links }
      when String
         { icon_link: [ parse_line( line ) ] }
      when NilClass
      else
         @errors << Parsers::BukovinaInvalidClass.new( "Invalid class " +
            "#{line.class} for Name line '#{line}'" ) ; end

      @errors.empty? && res || nil ; end

   private

   def valid? url
      uri = URI.parse( url )
      uri.kind_of?( URI::HTTP )
   rescue URI::InvalidURIError => e
      # URI::InvalidURIError: URI must be ascii only
      line = e.to_s.split('\u{').map do |tok|
         /^(?<num>[a-f0-9]+)/ =~ tok; num&.hex ; end
      .compact.pack("U*")
      alphabeth_code = detect_alphabeth_code( line )
      alphabeth_code && ! Parsers::MATCH_TABLE[ alphabeth_code ] !~ line ; end

   def detect_alphabeth_code desc
      if ! desc || desc.empty?
         return nil ; end

      fdesc = desc.gsub(/[0-9\s‑';:"«»©,()\.\-\?\/_a-zA-Z%~+&^]/,'')
      if fdesc.empty?
         return :ру ; end

      Parsers::MATCH_TABLE.each do |lang, re|
         if re =~ fdesc
            return lang ; end ; end

      false ; end

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_line line
      match = /^(?<url>http[^\[]+)(?:\[(?<desc>[^\]]+)\])?$/ =~ line
      url = url&.strip
      if ! match
         @errors << Parsers::BukovinaInvalidUrlFormatError.new( "Invalid url" +
            " line for #{line}" )
         nil
      elsif ! valid?( url )
         @errors << Parsers::BukovinaInvalidUrlFormatError.new( "Invalid url" +
            " format for #{line}" )
         nil
      else
         alphabeth_code = detect_alphabeth_code( desc )
         if alphabeth_code == false
            @errors << Parsers::BukovinaInvalidCharError.new( "Invalid " +
               "char(s) for description '#{desc}' specified" )
            nil
         else
            res = { url: url }
            if desc
              language_codes = Language.language_list_for(alphabeth_code)
              res[:descriptions] = [ { alphabeth_code: alphabeth_code,
                                    language_code: language_codes.first.to_sym,
                                    text: desc } ] ;end
            res ;end;end;end


   def initialize
      @errors = [] ; end ; end
