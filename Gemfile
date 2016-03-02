source 'https://rubygems.org'

# Specify your gem's dependencies in bukovina.gemspec
gemspec

#gem 'rdoba', :git => 'https://github.com/3aHyga/rdoba.git'
gem 'rdoba', :path => '/usr/local/home/majioa/git/rdoba'
#gem 'petrovich', :path => '/usr/local/home/majioa/git/petrovich-ruby/'

gem 'flag_shih_tzu'
gem 'i18n'

group :development do
   gem 'cucumber'
   gem 'spork'
   gem 'shoulda-matchers', github: 'majioa/shoulda-matchers', branch: 'allow_to_use_the_matchers_with_just_rspec_expectations_gem'
   gem 'rspec-expectations'
   gem 'activerecord', github: 'rails/rails', branch: 'v5.0.0.beta2'
   gem 'factory_girl'
   gem 'ffaker'
   gem 'database_cleaner'
   gem 'sqlite3'
   # To fix CVE-2015-7499 - HEAP-BASED BUFFER OVERFLOW VULNERABILITY IN LIBXML2 and others in LIBXML2
   gem 'nokogiri', '~> 1.6.7.2' ; end

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

      return name, prefix ; end ; end
