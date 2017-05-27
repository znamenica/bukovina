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

      MAP = {
         Bukovina::Parsers::Name => %w(имя name),
         Bukovina::Parsers::Patronymic => %w(отчество patronymic),
         Bukovina::Parsers::LastName => %w(фамилия last_name),
         Bukovina::Parsers::NickName => %w(прозвище nick_name),
         Bukovina::Parsers::Description => %w(описание description),
         Bukovina::Parsers::IconLink => %w(образ icon_link),
         Bukovina::Parsers::Link => %w(бытие link),
         Bukovina::Parsers::ServiceLink => %w(служба service_link),
         Bukovina::Parsers::Event => %w(событие event),
#         Bukovina::Parsers::Memo => %w(помин memo),
      }

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

      def load_seed
         errors = {}
         pass = true
         patron = Bukovina::Parsers::Patronymic.new
         namer = Bukovina::Parsers::Name.new
         lnamer = Bukovina::Parsers::LastName.new
         nnamer = Bukovina::Parsers::NickName.new
         desc = Bukovina::Parsers::Description.new
         ilink = Bukovina::Parsers::IconLink.new
         link = Bukovina::Parsers::Link.new
         slink = Bukovina::Parsers::ServiceLink.new
         eventer = Bukovina::Parsers::Event.new
         up = [ /Мария Богородица/ ]
         Dir.glob( 'памяти/**/память.*.yml' ).sort do |x,y|
            eva = proc { |v| up.any? { |u| u =~ v } }
            eva[x] && -1 || eva[y] && 1 || x <=> y ;end
         .each do |f|
#            binding.pry
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
               wd = Dir.pwd
               Dir.chdir( File.dirname( f ) )

               folder = File.basename( File.dirname( f ) )
               if folder != short_name
                  @errors << Errno::ENOENT.new( "Folder #{short_name.inspect}" +
                     " matches not for the memory #{short_name.inspect} itself" )
               end
               #####
#               attr_lists = namer.parse( data[ 'имя' ] )
#
#               if attr_lists
#                  attr_lists[ :name ].each do |attrs|
#                     Bukovina::Importers::Name.new(attrs).import ; end
#
#                  o_attrs = { memory: memory }
#                  attr_lists[ :memory_name ].each do |attrs|
#                     Bukovina::Importers::MemoryName.new(attrs, o_attrs).import
#                     end ; end
#               namer.errors.each { |e| errors[ f ] = e }.clear
#
#               attr_lists = patron.parse( data[ 'отчество' ] )
#
#               if attr_lists
#                  attr_lists[ :name ].each do |attrs|
#                     Bukovina::Importers::Name.new(attrs).import ; end
#
#                  o_attrs = { memory: memory }
#                  attr_lists[ :memory_name ].each do |attrs|
#                     Bukovina::Importers::MemoryName.new(attrs, o_attrs).import
#                     end ; end
#
#               patron.errors.each { |e| errors[ f ] = e }.clear
#
#               attr_lists = lnamer.parse( data[ 'фамилия' ] )
#
#               if attr_lists
#                  attr_lists[ :name ].each do |attrs|
#                     Bukovina::Importers::Name.new(attrs).import ; end
#
#                  o_attrs = { memory: memory }
#                  attr_lists[ :memory_name ].each do |attrs|
#                     Bukovina::Importers::MemoryName.new(attrs, o_attrs).import
#                     end ; end
#
#               lnamer.errors.each { |e| errors[ f ] = e }.clear
#
#               attr_lists = nnamer.parse( data[ 'прозвище' ] )
#
#               if attr_lists
#                  attr_lists[ :name ].each do |attrs|
#                     Bukovina::Importers::Name.new(attrs).import ; end
#
#                  o_attrs = { memory: memory }
#                  attr_lists[ :memory_name ].each do |attrs|
#                     Bukovina::Importers::MemoryName.new(attrs, o_attrs).import
#                     end ; end
#
#               nnamer.errors.each { |e| errors[ f ] = e }.clear
#
#               attr_lists = desc.parse( data[ 'описание' ] )
#
#               if attr_lists
#                  attr_lists[ :description ].each do |attrs|
#                     attrs.merge!( memory: { short_name: short_name} )
#                     Bukovina::Importers::Description.new( attrs ).import ; end
#                     end
#
#               desc.errors.each { |e| errors[ f ] = e }.clear
#
#               attr_lists = link.parse( data[ 'вики' ] )
#
#               if attr_lists
#                  attr_lists[ :link ].each do |attrs|
#                     attrs.merge!( memory: { short_name: short_name} )
#                     Bukovina::Importers::WikiLink.new( attrs ).import ; end
#                     end
#
#               link.errors.each { |e| errors[ f ] = e }.clear
#
#               attr_lists = link.parse( data[ 'бытие' ] )
#
#               if attr_lists
#                  attr_lists[ :link ].each do |attrs|
#                     attrs.merge!( memory: { short_name: short_name} )
#                     Bukovina::Importers::BeingLink.new( attrs ).import ; end
#                     end
#
#               link.errors.each { |e| errors[ f ] = e }.clear
#
#               attr_lists = link.parse( data[ 'отечник' ] )
#
#               if attr_lists
#                  attr_lists[ :link ].each do |attrs|
#                     attrs.merge!( memory: { short_name: short_name} )
#                     Bukovina::Importers::PatericLink.new( attrs ).import ; end
#                     end
#
#               link.errors.each { |e| errors[ f ] = e }.clear
#
#               attr_lists = ilink.parse( data[ 'образ' ] )
#
#               if attr_lists
#                  attr_lists[ :icon_link ].each do |attrs|
#                     attrs.merge!( memory: { short_name: short_name} )
#                     Bukovina::Importers::IconLink.new( attrs ).import ; end
#                     end
#
#               ilink.errors.each { |e| errors[ f ] = e }.clear
#
#               if short_name == 'Исаия Пророк'

#               attr_lists = slink.parse( data[ 'служба' ], target: short_name )
#
#               if attr_lists
#                  elist = (attr_lists.keys | [ :link, :service ]) - [:link, :service]
#                  if elist.any?
#                     errors << StandardError.new("Exceeded key list #{elist}") ;end
#
#                  attr_lists[ :link ]&.each do |attrs|
#                     attrs.merge!( memory: { short_name: short_name} )
#                     i = Bukovina::Importers::ServiceLink.new( attrs )
#                     i.import ;end
#
#                  attr_lists[ :service ]&.each do |attrs|
#                     attrs.merge!( memory: { short_name: short_name} )
#                     i = Bukovina::Importers::Service.new( attrs )
#                     i.import
#                     i.errors.each { |e| errors[ f ] = e } ;end ;end
#
#               slink.errors.each { |e| errors[ f ] = e }.clear
#
               # ---
#               attr_lists = eventer.parse( data[ 'событие' ] )
#
#               if attr_lists
#                  binding.pry
#                  attr_lists[ :event ].each do |attrs|
#                     attrs.merge!( memory: { short_name: short_name } )
#                     Bukovina::Importers::Event.new( attrs ).import ;end;end
#
#               eventer.errors.each { |e| errors[ f ] = e }.clear

               Dir.chdir( wd )
               end ; end

         if ! errors.keys.empty?
            errors.each do |n,e|
               puts "#{n}: #{e.class}:#{e}: #{e.backtrace&.join("\n")}" ; end
            raise "Simple load errors found " +
               "with count of #{errors.keys.size}" ; end ; end ; end

   def self.load_folders *folders
      files = folders.flatten.map do |folder|
         path = Rails.root.join( "#{folder}/**/*.rb" )
         Dir.glob( path ).sort.each { |r| require( r ) } ;end
      Kernel.puts( files.join("\n") ) ;end

   def self.application
      Kernel.puts "Access to app..."
      if !@app
         Kernel.puts "Loading app..."
         load_folders( 'config/initializers', 'app/validators',
            'app/models/concern', 'app' )
         Kernel.puts "..."
         @app = App.new ; end
      @app ; end

   def self.root
      @root ||= Pathname.new( File.expand_path('../../', __FILE__) ) ; end

   def self.env
      @env ||= ENV['RAILS_ENV'] || 'development' ; end ; end
