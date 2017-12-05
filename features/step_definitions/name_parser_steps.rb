Допустим(/^есть строк[иа] имени:$/) do |string|
   @parser = Bukovina::Parsers::Name.new
   @res = @parser.parse( YAML.load( string ) ) ; end

То(/^обработанные данные имени будут выглядеть как:$/) do |string|
   binding.pry if ENV['DEBUG']
   expect( @res[ :names ].to_yaml.strip ).to be_eql( string.to_s ) ; end

То(/^обработанные данные памятного имени будут выглядеть как:$/) do |string|
   binding.pry if ENV['DEBUG']
   expect( @res[ :memory_names ].to_yaml.strip ).to be_eql( string.to_s ) ; end

То(/^обработанных данных не будет$/) do
   expect( @res ).to be_nil ; end

То(/^в списке ошибок будет (?:(\d+) )?ошибк[аи] "([^"]*)"$/) do |count, text|
   name = Bukovina::Parsers
   types = {
      'индекса' => name::BukovinaIndexError,
      'неверного языка' => name::BukovinaInvalidLanguageError,
      'неверной буквы языка' => name::BukovinaInvalidCharError,
      'неверного признака' => name::BukovinaInvalidTokenError,
      'неверного перечислителя' => name::BukovinaInvalidEnumeratorError,
      'ложного правописания' => name::BukovinaFalseSyntaxError,
      'неверного формата ссылки' => name::BukovinaInvalidUrlFormatError,
   }
   value = Array.new( ( count || 1 ).to_i ) { types[ text ] }
   expect( @parser.errors ).to match_array( value ) ; end
