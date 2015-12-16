# load rails components
#root = File.expand_path('../', __FILE__)
#$LOAD_PATH.unshift(root) unless $LOAD_PATH.include?(root)

require 'active_record'
require "bukovina/version"

module Bukovina
   def self.run
      require File.join( File.dirname( __FILE__ ), '../config/environment.rb' )
   end
end

require "bukovina/parsers"
