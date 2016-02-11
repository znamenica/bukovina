require 'bukovina'
require 'active_record'
require 'active_support'
require 'yaml'
require 'pry'
require 'rdoba'
require 'rdoba/merge'

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
               File.join( Rails.root, 'config/database.yml' ) ) ) ; end ; end

      def initialize
         @config = Config.new
         ActiveRecord::Base.logger = Logger.new(STDERR)
         ActiveRecord::Base.establish_connection(
            @config.database_configuration[Rails.env])

         # custom
         @errors = [] ; end

      def paths
         { 'db/migrate' => [ 'db/migrate' ] } ; end

      def validate_record record
         short_name = record.keys.first
         # TODO Validate memory, it will validate subfiieds itself

         data = record[ short_name ]

         namer = Bukovina::Parsers::Name.new
         namer.parse data[ 'имя' ]
         @errors.concat namer.errors ; end

      def validate
         Dir.glob( 'памяти/**/память.*.yml' ).each do |f|
            puts "Память: #{f}"

            m = begin
               YAML.load( File.open( f ) )
            rescue Psych::SyntaxError => e
               @errors << "#{e} for file #{f}" ; nil ; end

            if m
               validate_record m ; end ; end ; end

      def load_seed
         errors = {}
         pass = true
         patron = Bukovina::Parsers::Patronymic.new
         Dir.glob( 'памяти/**/память.*.yml' ).each do |f|
            puts "Память: #{f}"
            m = begin
               YAML.load( File.open( f ) )
            rescue Psych::SyntaxError => e
               errors[ f ] = e ; nil ; end

            if m
               short_name = m.keys.first
               memory = 
               Memory.by_short_name( short_name ).first_or_create do |memory|
                  memory.short_name = short_name ; end

               data = m[ short_name ]
=begin
               namer = Bukovina::Parsers::Name.new
               attr_lists = namer.parse( data[ 'имя' ] )

               if attr_lists
                  attr_lists[ :name ].each do |attrs|
                     Bukovina::Importers::Name.new(attrs).import ; end

                  o_attrs = { memory: memory }
                  attr_lists[ :memory_name ].each do |attrs|
                     Bukovina::Importers::MemoryName.new(attrs, o_attrs).import
                     end ; end
=end
               attr_lists = patron.parse( data[ 'отчество' ] )

               if attr_lists
                  attr_lists[ :name ].each do |attrs|
                     Bukovina::Importers::Name.new(attrs).import ; end

                  o_attrs = { memory: memory }
                  attr_lists[ :memory_name ].each do |attrs|
                     Bukovina::Importers::MemoryName.new(attrs, o_attrs).import
                     end ; end


#               namer.errors.each { |e| errors[ f ] = e }.clear
               patron.errors.each { |e| errors[ f ] = e }.clear
               end ; end
   
         if ! errors.keys.empty?
            errors.each do |n,e|
               puts "#{n}: #{e.class}:#{e}: #{e.backtrace&.join("\n")}" ; end
            raise "Simple load errors found " +
               "with count of #{errors.keys.size}" ; end ; end ; end

   def self.application
      if !@app
         Dir.glob( Rails.root + '/app/**/*.rb' ).each { |r| require( r ) }
         @app = App.new ; end
      @app ; end

   def self.root
      @root ||= File.expand_path('../../', __FILE__) ; end

   def self.env
      @env ||= ENV['RAILS_ENV'] || 'development' ; end ; end
