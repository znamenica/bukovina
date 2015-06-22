require 'active_record'
require 'yaml'

Dir[ './lib/app/**/*.rb' ].each {|file| require file }
 
module Rails
   class App
      attr_reader :config

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
      end

      def paths
         { 'db/migrate' => [ 'lib/db/migrate' ] }
      end

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
               name = m.keys.first
               Memory.where( short_name: name ).first_or_create do |memory|
                  memory.short_name = name
               end
            end
         end
   
         if !errors.keys.empty?
            errors.each { |n,e| puts "#{n}: #{e.class}:#{e}: #{e.backtrace.join("\n")}" }
            raise "YAML Simlpe load errors found with count of #{errors.keys.size}"
         end
      end
   end

   def self.application
      @@app ||= App.new
   end
end
