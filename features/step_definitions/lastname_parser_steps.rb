Допустим(/^есть строк[аи] фамилии:$/) do |string|
   @namer = Bukovina::Parsers::LastName.new
   @res = @namer.parse( YAML.load( string ) ) ; end
