# load rails components
#root = File.expand_path('../', __FILE__)
#$LOAD_PATH.unshift(root) unless $LOAD_PATH.include?(root)

require 'validate_url'
require 'active_record'
require 'bukovina/version'

module Bukovina
   def self.root
      Pathname.new(Gem::Specification.find_by_name('bukovina').full_gem_path)
   end

   def self.run
      require File.join( File.dirname( __FILE__ ), '../config/environment.rb' )
   end
end

require 'bukovina/parsers'
require 'bukovina/importers'
require 'bukovina/engine'
require 'bukovina/tasks'
