require 'uri'

class Bukovina::Parsers::Link
   attr_reader :errors

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse line
      # TODO skip return if errors found
      #
      res =
      case line
      when Hash
         links = line.map { |(lang, url)| parse_line( url, lang ) }.compact
         { link: links }
      when String
         { link: [ parse_line( line ) ] }
      when NilClass
      else
         raise Parsers::BukovinaInvalidClass, "Invalid class #{name.class} " +
            "for Name line '#{name}'" ; end

      @errors.empty? && res || nil ; end

   private

   def valid? url
      uri = URI.parse( url )
      uri.kind_of?( URI::HTTP )
   rescue URI::InvalidURIError
      false ; end

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_line line, language_code = 'ру'
      language_code = language_code.to_sym

      if ! Parsers::MATCH_TABLE[ language_code ]
         @errors << Parsers::BukovinaInvalidLanguageError.new( "Invalid " +
            "language '#{language_code}' specified" )
         return nil ; end

      match = /^(?<url>http[^\s]+)(?:\s*\[(?<desc>[^\]]+)\])?$/ =~ line
      if ! match
         @errors << Parsers::BukovinaInvalidUrlFormatError.new( "Invalid url" +
            " line for #{line}" )
         nil
      elsif desc && Parsers::MATCH_TABLE[ language_code ] !~
            desc.gsub(/[0-9\s‑';:",()\.\-\?\/]/,'')
         @errors << Parsers::BukovinaInvalidCharError.new( "Invalid " +
            "char(s) for language '#{language_code}' specified" )
         nil
      elsif ! valid?( url )
         @errors << Parsers::BukovinaInvalidUrlFormatError.new( "Invalid url" +
            " format for #{line}" )
         nil
      else
         res = { language_code: language_code, url: url }
         if desc
            res[ :description ] = { language_code: language_code, text: desc }
            end
         res ; end ; end

   def initialize
      @errors = [] ; end ; end
