require 'bukovina'
require 'yaml'
Bundler.require(:default)
Bundler.require(:development)
require 'rdoba/merge'

# w/a
class Hash
   include Rdoba::Merge ; end

module Rails

   class App
      rdoba :log

      attr_reader :config, :errors

      class Config
         def paths
            { 'db' => [ 'config' ] } ; end

         def database_configuration
            @dbconfig ||= YAML.load( File.open(
               Rails.root.join( 'config/database.yml' ) ) )
            ActiveRecord::Base.configurations = @dbconfig ; end ; end

      def initialize
         @config = Config.new
         #TODO replace with rdoba.log
         ActiveRecord::Base.logger = Logger.new( File.open( '/dev/null', 'w' ) )
         ActiveRecord::Base.establish_connection(
            @config.database_configuration[Rails.env])

         I18n.load_path.concat( Dir.glob( Rails.root.join( "config/locales/**/*.yml" ) ) )
         # custom
         @errors = {} ; end

      def paths
         { 'db/migrate' => [ 'db/migrate' ] } ; end

      def validate_calendary f, record
         short_name = record.keys.first
         file_short_name = f.split('/')[-2]
         if short_name != file_short_name
            @errors[f] = [StandardError.new("File calendary name " +
               "#{file_short_name} doesn't match to calendary name #{short_name}")] ;end
         data = record[ short_name ]

         parser = Bukovina::Parsers::Calendary.new
         parser.parse(data)
         if parser.errors.any?
            @errors[f] = parser.errors ;end;end


      def validate_record f, record
         short_name = record.keys.first
         file_short_name = f.split('/')[-2]
         if short_name != file_short_name
            @errors[f] = [StandardError.new("File short name " +
               "#{file_short_name} doesn't match to short name #{short_name}")] ;end
         # TODO Validate memory, it will validate subfiieds itself

         data = record[ short_name ]

         parser = Bukovina::Parsers::Memory.new
         parser.parse(data)
         if parser.errors.any?
            @errors[f] = parser.errors ;end;end


      def validate
         Dir.glob( 'календари/**/память.*.yml' ).each do |f|
            puts "Календарь: #{f}"

            m = begin
               YAML.load( File.open( f ) )
            rescue Psych::SyntaxError => e
               @errors[f] = [ StandardError.new("#{e} for file #{f}")] ; nil ; end

            if m
               wd = Dir.pwd
               Dir.chdir( File.dirname( f ) )
               validate_calendary(f, m)
               Dir.chdir( wd ) ;end;end

         Dir.glob( 'памяти/**/память.*.yml' ).each do |f|
            puts "Память: #{f}"

            m = begin
               YAML.load( File.open( f ) )
            rescue Psych::SyntaxError => e
               @errors[f] = {root: [StandardError.new("#{e} for file #{f}")]} ; nil ; end

            if m
               wd = Dir.pwd
               Dir.chdir( File.dirname( f ) )
               validate_record(f, m)
               Dir.chdir( wd ) ;end;end

         puts '-'*80
         errors.keys.each do |f|
            puts "#{f.gsub(/([ ,])/,'@\1').gsub('@','\\')}" ;end
         puts '='*80

         errors.each do |f, list|
            list.each do |e|
               puts "@@@ #{f} -> #{e.class}:#{e.message}" ; end;end

         true; end


      def import_calendary f, record
         short_name = record.keys.first
         file_short_name = f.split('/')[-2]
         if short_name != file_short_name
            @errors[f] = [StandardError.new("File calendary name " +
               "#{file_short_name} doesn't match to calendary name #{short_name}")] ;end
         data = record[ short_name ]

         parser = Bukovina::Parsers::Calendary.new
         attrs = parser.parse(data)
         if parser.errors.any?
            @errors[f] = parser.errors
         else
            i = Bukovina::Importers::Calendary.new( attrs )
            i.import
            @errors[ f ] = i.errors if i.errors.any? ;end;end


      def import_record f, record
         short_name = record.keys.first
#         return  if short_name != 'Василий Волыньский' ####
         file_short_name = f.split('/')[-2]
         if short_name != file_short_name
            @errors[f] = [StandardError.new("File short name " +
               "#{file_short_name} doesn't match to short name #{short_name}")] ;end
         # TODO Validate memory, it will validate subfiieds itself

         data = record[ short_name ]

         parser = Bukovina::Parsers::Memory.new
         attrs = parser.parse(data)
         if parser.errors.any?
            @errors[f] = parser.errors
         else
            Bukovina::Importers::Memory.new( attrs, short_name ).import( short_name ) ;end;end


      def load_seed; end;end

   def self.load_folders *folders
      files = folders.flatten.map do |folder|
         path = Rails.root.join( "#{folder}/**/*.rb" )
         Dir.glob( path ).sort.each { |r| require( r ) } ;end
      # Kernel.puts( files.join("\n") )
      end

   def self.application
      # Kernel.puts "Access to app..."
      if !@app
         # Kernel.puts "Loading app..."
         load_folders( 'config/initializers', 'app/validators',
            'app/models/concern', 'app' )
         # Kernel.puts "..."
         @app = App.new ; end
      @app ; end

   def self.root
      @root ||= Pathname.new( File.expand_path('../../', __FILE__) ) ; end

   def self.env
      @env ||= ENV['RAILS_ENV'] || 'development' ; end ; end
