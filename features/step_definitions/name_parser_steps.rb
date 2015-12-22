Допустим(/^есть строка имени:$/) do |string|
   namer = Bukovina::Parsers::Name.new
   @res = namer.parse( string.strip ) ; end

Допустим(/^есть строки имени:$/) do |string|
   namer = Bukovina::Parsers::Name.new
   @res = namer.parse( YAML.load( string ) ) ; end

То(/^обработанные данные имени будут выглядеть как:$/) do |string|
   expect( @res[ :name ].to_yaml.strip ).to be_eql( string.to_s ) ; end

То(/^обработанные данные памятного имени будут выглядеть как:$/) do |string|
   expect( @res[ :memory_name ].to_yaml.strip ).to be_eql( string.to_s ) ; end
