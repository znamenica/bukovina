# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bukovina/version'

Gem::Specification.new do |spec|
  spec.name          = "bukovina"
  spec.version       = Bukovina::VERSION
  spec.authors       = ["Malo Skrylevo"]
  spec.email         = ["majioa@yandex.ru"]
  spec.description   = %q{Bukovina is the Orthodox Christian God-service library}
  spec.summary       = %q{Bukovina is the Orthodox Christian God-service library}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'hashie'
  spec.add_dependency 'mechanize'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry_debug"
  spec.add_development_dependency "rake"
end
