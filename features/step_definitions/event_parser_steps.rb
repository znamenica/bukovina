Допустим(/^есть строк[аи] события:$/) do |string|
   @parser = Bukovina::Parsers::Event.new
   @res = @parser.parse( YAML.load( string ) ) ; end

То(/^обработанные данные события будут выглядеть как:$/) do |string|
   expect( @res.to_yaml.strip ).to be_eql( string.to_s ) ; end
