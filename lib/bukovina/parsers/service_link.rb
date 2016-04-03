require 'uri'
require 'rdoba'

class Bukovina::Parsers::ServiceLink
   attr_reader :errors

   rdoba mixin: :split_by

   ALPHABETHS = {
      'hip' => :цр, #церковнославянская разметка hip
      'ру' => :ру,
      'ро' => :ро,
      'ан' => :ан,
      'en' => :ан,
      'гр' => :гр,
      'ив' => :ив,
      'рм' => :рм,
      'ук' => :ук,
      'ср' => :ср,
      'gr' => :гр,
      'fr' => :фр,
   }

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse line
      tres =
      case line
      when Array
         (links, aservices) = line.map do |url|
            if url.is_a?( Array )
               url.map do |u|
                  parse_line( u ) ; end.compact
            else
               parse_line( url ) ; end ; end
         .compact.flatten
      when String
         parse_line( line )
      when NilClass
         []
      else
         @errors << Parsers::BukovinaInvalidClass.new( "Invalid class " +
            "#{line.class} for Name line '#{line}'" )
         [] ; end

      if @errors.any?
         nil
      else
         (links, services) = tres.split_by do |value|
            value.has_key?( :url ) ;end

         { link: links, service: services }
         end ;end

   private

   def collect_errors parser, line, alphabeth_code
      parser.errors.each do |error|
         error.message << " for service #{line.inspect} with language #{alphabeth_code}"
         @errors << error ; end
      parser.errors.clear ; end

   def valid? url, alphabeth_code
      uri = URI.parse( url )
      uri.kind_of?( URI::HTTP )
   rescue URI::InvalidURIError => e
      # URI::InvalidURIError: URI must be ascii only
      if /^https?:\/\// !~ url
         return false ; end

      line = e.to_s.split('\u{').map do |tok|
         /^(?<num>[a-f0-9]+)/ =~ tok; num&.hex ; end
      .compact.pack("U*")

      line.size > 0 && ! Parsers::MATCH_TABLE[ alphabeth_code ] !~ line ; end

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_line line, alphabeth_code = 'ро'
      alphabeth_code = alphabeth_code.to_sym

      if ! Parsers::MATCH_TABLE[ alphabeth_code ]
         @errors << Parsers::BukovinaInvalidLanguageError.new( "Invalid " +
            "language '#{alphabeth_code}' specified" )
         return nil

      elsif ! valid?( line, alphabeth_code )
         if / служба$/ =~ line
            filemask = File.join( Dir.pwd, line )
            files = Dir.glob( "#{filemask}*" )
            if files.empty?
               @errors << Parsers::BukovinaNoFilesMatched.new(
                  "No files were matched for service #{line}" ) ;end

            parsed =
            files.map do |file|
               if /(~|swp)$/ =~ file
                  next ;end

               /\.(?<lang>[^\.]+)\.(?<format>yml|hip)$/ =~ file
               if ! format || ! lang
                  @errors << Parsers::BukovinaInvalidFileNameFormat.new(
                     "Invalid file name format for #{file}" )
               elsif format == 'hip'
                  parser = Parsers::PlainService.new
                  parsed = parser.parse( IO.read( file ) )
                  if ! parsed
                     collect_errors( parser, line, alphabeth_code )
                     nil
                  else
                     { alphabeth_code: :цр, name: line, text_format: 'hip' }.
                        merge( parsed ) ;end

               else
                  parser = Parsers::Service.new
                  begin
                     service = YAML.load( IO.read( file ) )
                  rescue Psych::SyntaxError
                     @errors << Parsers::BukovinaFalseSyntaxError.new("#{$!.message}: " +
                        "wrong yaml syntax in file #{file}")
                     next
                  end

                  /(?:.*_)?(?<al>.*)/ =~ lang
                  if ! ALPHABETHS[ al ]
                     @errors << Parsers::BukovinaInvalidLanguageError.new(
                        "Invalid alphabeth #{al} for #{file}" )
                     next ;end

                  parsed =
                  parser.parse( service, alphabeth_code: ALPHABETHS[ al ] )
                  if ! parsed
                     collect_errors( parser, line, alphabeth_code )
                     nil
                  else
                     { alphabeth_code: ALPHABETHS[ al ], name: line }.merge(
                        parsed ) ;end ;end; end
            .compact.flatten

            parsed
         else
            @errors << Parsers::BukovinaInvalidUrlFormatError.new( "Invalid url" +
               " format for #{line}" )
            nil ; end

      else
         [ { alphabeth_code: ALPHABETHS[ alphabeth_code.to_s ], url: line } ]
         end ;end

   def initialize
      @errors = [] ; end ; end
