Допустим(/^есть строк[иа] ссылки:$/) do |string|
   @parser = Bukovina::Parsers::Link.new
   @res = @parser.parse( YAML.load( string ) ) ; end

То(/^обработанные данные ссылки будут выглядеть как:$/) do |string|
   expect( @res[ :link ].to_yaml.strip ).to be_eql( string.to_s ) ; end
