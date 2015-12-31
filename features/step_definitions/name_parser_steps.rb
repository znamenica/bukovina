Допустим(/^есть строка имени:$/) do |string|
   @namer = Bukovina::Parsers::Name.new
   @res = @namer.parse( string.strip ) ; end

Допустим(/^есть строки имени:$/) do |string|
   @namer = Bukovina::Parsers::Name.new
   @res = @namer.parse( YAML.load( string ) ) ; end

То(/^обработанные данные имени будут выглядеть как:$/) do |string|
   expect( @res[ :name ].to_yaml.strip ).to be_eql( string.to_s ) ; end

То(/^обработанные данные памятного имени будут выглядеть как:$/) do |string|
   expect( @res[ :memory_name ].to_yaml.strip ).to be_eql( string.to_s ) ; end

То(/^обработанных данных имени не будет$/) do
   expect( @res ).to be_nil ; end

То(/^в списке ошибок будет "([^"]*)"$/) do |text|
   name = Bukovina::Parsers::Name
   types = {
      'ошибка индекса' => name::BukovinaIndexError,
      'ошибка неверного языка' => name::BukovinaInvalidLanguageError,
      'ошибка неверной буквы языка' => name::BukovinaInvalidCharError,
      'ошибка неверного признака' => name::BukovinaInvalidTokenError,
      'ошибка неверного заменятеля' => name::BukovinaInvalidVariatorError,
      'ошибка неверного перечислителя' => name::BukovinaInvalidEnumeratorError,
   }
   expect( @namer.errors ).to match_array( [ types[ text ] ] ) ; end
