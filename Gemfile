source 'https://rubygems.org'

# Specify your gem's dependencies in bukovina.gemspec
gemspec

gem 'rdoba', :git => 'https://github.com/3aHyga/rdoba.git'
#gem 'rdoba', :path => '/usr/local/home/majioa/git/rdoba'
#gem 'petrovich', :path => '/usr/local/home/majioa/git/petrovich-ruby/'

group :development do
   gem 'cucumber'
   gem 'shoulda-matchers', github: 'majioa/shoulda-matchers'
   gem 'flag_shih_tzu'
   gem 'rspec-expectations'
   gem 'activerecord'
   gem 'database_cleaner'
   gem 'sqlite3'
end

require 'rubygems/package'

class Gem::Package::TarWriter
   def split_name name
      if name.bytesize <= 100 then
         prefix = ""
      else
         parts = name.split(/\//)
         newname = parts.pop
         nxt = ""

         loop do
            nxt = parts.pop
            break if newname.bytesize + 1 + nxt.bytesize > 100
            newname = nxt + "/" + newname
         end

         prefix = (parts + [nxt]).join "/"
         name = newname
      end

      return name, prefix
   end
end
