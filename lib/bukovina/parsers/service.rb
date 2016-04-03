class Bukovina::Parsers::Service
   attr_reader :errors

   Parsers = Bukovina::Parsers

   VALID_PATHS = [
      'вечерня.возвашна',
      'вечерня.отпустительно.тропарь',
      'вечерня.отпустительно.молитва',
      'вечерня.отпустительно.богородичен',
      'евангелие',
      'апостол',
      'вечерня.лития.стихира.0',
      'вечерня.лития.стихира',
      'вечерня.стиховен.стихира',
      'утреня.кафисма.0.седален',
      'утреня.кафисма.седален',
      'утреня.полиелей.седален',
      'утреня.величание',
      'утреня.канон.кондак',
      'утреня.канон.икос',
      'утреня.канон.седален',
      'описание',
      'источник',
      'автор',
   ]

   KINDS = {
      'тропарь' => 'Troparion',
      'кондак' => 'Kontakion',
      'седален' => 'SessionalHymn',
      'светилен' => 'Exapostilarion',
      'стихира' => 'Stichira', #Praises (хвалитна), Ipakoi, степенна?, Resurrection, литийны, восточны
      'икос' => 'Ikos', #без подобна
      'ирмос' => 'Irmos',
      'величание' => 'Magnification', # и без гласа
      'молитва' => 'Prayer',
      'возвашна' => 'CryStichira',
      'богородичен' => 'Chant',###???
   }

   EXCLUDE_KINDS = [ 'Magnification' ]
   EXTEND_KINDS = {
      'Stichira' => {
         'стиховен' => 'Apostichus',
         'лития' => 'Stichiron',
      },
      'SessionalHymn' => {
         'кафисма' => 'Kathismion',
         'канон' => 'Kanonion',
         'полиелей' => 'Polileosion',
      }
   }

   PROPERTIES = {
      'глас' => :tone,
      'текст' => :text,
      'подобен' => :prosomeion_title,
      'крат' => :title, #нужно для подобна (и ссылки)
      'источник' => :source,
      'автор' => :author,
      'апостол' => :apostle,
      'евангелие' => :gospel,
      'описание' => :description,
   }

   MATCHERS = [
      /(?<kind>#{KINDS.keys.join('|')})\.(?<index>\d+)\.
       (?<property>#{PROPERTIES.keys.join('|')})/x,
      /(?<kind>#{KINDS.keys.join('|')})\.
       (?<property>#{PROPERTIES.keys.join('|')})/x,
      /(?<kind>#{KINDS.keys.join('|')})\.(?<index>\d+)/,
      /(?<kind>#{KINDS.keys.join('|')})/,
      /(?<property>#{PROPERTIES.keys.join('|')})/ ]


   def parse line, options = {}
      res =
      if line.is_a?( Hash )
         paths = collect_paths( line )
         parse_paths( paths, options )
      else
         @errors << Parsers::BukovinaInvalidClass.new( "Invalid class " +
            "#{line.class} for Name line '#{line}'" ) ; end

      @errors.empty? && res || nil ; end

   private

   def is_path_valid? path
      VALID_PATHS.any? do |vpath|
         /^#{vpath.gsub( /\./, '\.' ).gsub( /0/, '\d+' )}/ =~ path ;end ;end

   def parse_parts path
      kind = index = property = nil
      MATCHERS.any? do |m|
         if eval( "/#{m}/ =~ path" )
            return [
               KINDS[ kind ],
               index && index.to_i - 1 || nil,
               PROPERTIES[ property ] ] ;end ;end

      @errors << Parsers::BukovinaInvalidPathError.new( "Path " +
         "#{path.inspect} is unmatched" )

      nil ;end

   def parse_paths paths, options = {}
      alphabeth_code = options[ :alphabeth_code ]

      tree = {}
      paths.each do |path, value|
         if ! is_path_valid?( path )
            @errors << Parsers::BukovinaInvalidPathError.new( "Invalid path" +
               "#{path.inspect}" )
            next ;end

         (kind, index, property) = parse_parts( path )

         if ! kind && ! property
            @errors << Parsers::BukovinaInvalidPathError.new( "Unmatched" +
               " path #{path.inspect}" )
            next ;end

         property ||= :text
         index ||= 0

         if kind
            base = kind.constantize.base_class.to_s.tableize.pluralize.to_sym
            tree[ base ] ||= []
            tree[ base ][ index ] ||= {}
            tree[ base ][ index ][ :alphabeth_code ] ||= alphabeth_code
            if ! EXCLUDE_KINDS.include?( kind )
               tree[ base ][ index ][ :type ] ||= kind ;end
            tree[ base ][ index ][ property ] ||= value
         else
            tree[ property ] = value ;end ;end


      tree ;end

   def collect_paths data
      def collect_value value, key, paths
         case value
         when Hash
            up = collect_in_hash( value )
         when Array
            up = collect_in_array( value )
         else
            paths[ key.to_s ] = value ;end

         if up
            up.each do |uppath, upvalue|
               paths[ "#{key}.#{uppath}" ] = upvalue ;end ;end ;end

      def collect_in_array array
         paths = {}
         array.each.with_index do |value, index|
            collect_value value, index + 1, paths ;end

         paths ;end

      def collect_in_hash hash
         paths = {}
         hash.each do |key, value|
            collect_value value, key, paths ;end

         paths ;end

      collect_in_hash( data ) ;end


   def initialize
      @errors = [] ; end ; end
