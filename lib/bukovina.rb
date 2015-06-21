require "bukovina/version"

module Bukovina
   def self.run
      require File.join( File.dirname( __FILE__ ), 'config/environment.rb' )
   end
end
