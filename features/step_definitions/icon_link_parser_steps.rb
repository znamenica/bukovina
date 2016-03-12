Допустим(/^есть строка иконной ссылки:$/) do |string|
   @parser = Bukovina::Parsers::IconLink.new
   @res = @parser.parse( YAML.load( string ) ) ; end

То(/^обработанные данные иконной ссылки будут выглядеть как:$/) do |string|
   expect( @res[ :icon_link ].to_yaml.strip ).to be_eql( string.to_s ) ; end
