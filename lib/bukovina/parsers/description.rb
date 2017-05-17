class Bukovina::Parsers::Description
   attr_reader :errors

   Parsers = Bukovina::Parsers

   RE = /\A([#{Parsers::UPCHAR}#{Parsers::CHAR}#{Parsers::ACCENT}0-9\s‑;:'"«»\,’()\.\-\?\/]+)\z/
   # вход: значение поля "имя" включая словарь разных языков
   # выход: обработанный словарь данных

   def parse name
      # TODO skip return if errors found
      #
      res =
      case name
      when Hash
         descriptions = name.map do |(lang, desc)|
            res = parse_line( desc, lang )
            res&.[](:text) && res || nil
         end.compact

         { description: descriptions }
      when String
         { description: [ parse_line( name, :ру ) ] }
      when NilClass
      else
         raise Parsers::BukovinaInvalidClass, "Invalid class #{name.class} " +
               "for Name line '#{name}'" ; end

      @errors.empty? && res || nil

   rescue Parsers::BukovinaError => e
      @errors << e
      nil ; end

   protected

   def detect_alphabeth text, language_code
      language_code = language_code.to_sym

      alphs = Language::LANGUAGE_TREE[language_code]
      alph =
      [ alphs ].flatten.reduce do |res, alph|
         if Parsers::MATCH_TABLE[ language_code ] =~ line.gsub(/[0-9\s‑';:"«»,()\.\-\?\/]/,'')
            alph
         else
            res
         end
      end
   end

   def match_alphabeth? alphabeth_code, line
      filtered = line.gsub(/[0-9\s‑';:"«»,()№’\.\-\?\/]/,'')
      Parsers::MATCH_TABLE[ alphabeth_code ] =~ filtered
   end

   def grab_invalid_chars alphabeth_code, line
      filtered = line.gsub(/[0-9\s‑';:"«»,()№’\.\-\?\/]/,'')
      filtered.split('').map { |c| Parsers::MATCH_TABLE[ alphabeth_code ] !~ c && c || nil }.compact.uniq.join
   end

   # вход: значение поля "имя"
   # выход: обработанный словарь данных

   def parse_line line, alphabeth_code = :ру
      alphabeth_code = alphabeth_code.to_sym

      language_codes = Language.language_list_for(alphabeth_code)
      if language_codes.present?
         if match_alphabeth?( alphabeth_code, line )
            {  alphabeth_code: alphabeth_code,
               language_code: language_codes.first.to_sym,
               text: line }
         else
            @errors << Parsers::BukovinaInvalidCharError.new( "Invalid " +
               "char(s): \"#{grab_invalid_chars( alphabeth_code, line )}\" " +
               "for language '#{alphabeth_code}' specified" )
            nil ;end
      else
         @errors << Parsers::BukovinaInvalidLanguageError.new( "Invalid " +
            "alphabeth '#{alphabeth_code}' specified" )
         nil ;end;end

   def initialize
      @errors = [] ; end ; end
