require 'bukovina'
require 'active_record'
require 'yaml'
require 'pry'
require 'rdoba/merge'

class Hash
   include Rdoba::Merge ; end

Dir[ './lib/app/**/*.rb' ].each {|file| require file }
 
module Rails
   class App
      attr_reader :config, :errors

      class Config
         def paths
            { 'db' => [ 'lib/config' ] }
         end
      end

      def initialize
         dbconfig = YAML.load( File.open( File.join( File.dirname( __FILE__ ), 'database.yml' ) ) )
         ActiveRecord::Base.logger = Logger.new(STDERR)
         ActiveRecord::Base.establish_connection(dbconfig)
         @config = Config.new

         # custom
         @errors = []
      end

      def paths
         { 'db/migrate' => [ 'lib/db/migrate' ] }
      end

      def validate_record record
         short_name = record.keys.first
         # TODO Validate memory, it will validate subfiieds itself

         data = record[ short_name ]

         namer = Bukovina::Parsers::Name.new
         namer.parse data[ 'имя' ]
         @errors.concat namer.errors
      end

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
         Dir.glob( 'памяти/**/память.*.yml' ).each do |f|
            puts "Память: #{f}"
            m = begin
               YAML.load( File.open( f ) )
            rescue Psych::SyntaxError => e
               errors[ f ] = e ; nil
            end

            if m
               short_name = m.keys.first
               Memory.where( short_name: name ).first_or_create do |memory|
                  memory.short_name = short_name
               end

               data = m[ short_name ]

               namer = Bukovina::Parsers::Name.new
               namer.parse( data[ 'имя' ] ).each do |attrs|
                  name = Name.where( attrs[ 0 ] ).first_or_create( attrs[ 1 ].merge( attrs[ 0 ] ) )
               end
            end
         end
   
         if !errors.keys.empty?
            errors.each { |n,e| puts "#{n}: #{e.class}:#{e}: #{e.backtrace.join("\n")}" }
            raise "YAML Simple load errors found with count of #{errors.keys.size}"
         end
      end
   end

   def self.application
      @@app ||= App.new
   end
end
