require 'active_record'
require 'yaml'

Dir[ './lib/app/**/*.rb' ].each {|file| p file; require file }
 
dbconfig = YAML.load( File.open( File.join( File.dirname( __FILE__ ), 'database.yml' ) ) )
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(dbconfig)
