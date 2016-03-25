require 'uri'
require 'rdoba'

class Bukovina::Parsers::ServiceLink
   attr_reader :errors

   rdoba mixin: :split_by

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse line
      res =
      case line
      when Array
         (links, aservices) = line.map do |url|
            if url.is_a?( Array )
               url.map do |u|
                  parse_line( u ) ; end.compact
            else
               parse_line( url ) ; end ; end
         .compact.flatten.split_by { |value| value.try( :has_key?, :url ) }

         (plain_services, services) =
         aservices.split_by { |value| value.is_a?( String ) }

         { link: links, service: services, plain_service: plain_services }
      when String
         res = parse_line( line )
         if res&.has_key?(:url)
            { link: [ res ] }
         elsif res.is_a?( String )
            { plain_service: [ res ] }
         else
            { service: [ res ] } ; end
      when NilClass
      else
         @errors << Parsers::BukovinaInvalidClass.new( "Invalid class " +
            "#{line.class} for Name line '#{line}'" ) ; end

      @errors.empty? && res || nil ; end

   private

   def collect_errors parser, line
      parser.errors.each do |error|
         error.message << " for service #{line.inspect}"
         @errors << error ; end
      parser.errors.clear ; end

   def valid? url, language_code
      uri = URI.parse( url )
      uri.kind_of?( URI::HTTP )
   rescue URI::InvalidURIError => e
      # URI::InvalidURIError: URI must be ascii only
      if /^https?:\/\// !~ url
         return false ; end

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
         if / служба$/ =~ line
            filemask = File.join( Dir.pwd, line )
            parsed =
            Dir.glob( "#{filemask}*" ).map do |file|

               /\.(?<lang>[^\.]+)\.(?<format>yml|hip)$/ =~ file
               if ! format || ! lang
                  @errors << Parsers::BukovinaInvalidFileNameFormat.new(
                     "Invalid file name format for #{file}" )
               elsif format == 'hip'
                  parser = Parsers::PlainService.new
                  parsed = parser.parse( IO.read( file ) )
                  if ! parsed
                     collect_errors( parser, line ) ; end
                  parsed
               else
                  parser = Parsers::Service.new
                  service = YAML.load( IO.read( file ) )
                  parsed = parser.parse( service )
                  if ! parsed
                     collect_errors( parser, line ) ; end
                  parsed ; end ; end.compact.flatten

#            binding.pry
            parsed
         else
            @errors << Parsers::BukovinaInvalidUrlFormatError.new( "Invalid url" +
               " format for #{line}" )
            nil ; end

      else
         { language_code: language_code, url: line } ; end ; end

   def initialize
      @errors = [] ; end ; end
