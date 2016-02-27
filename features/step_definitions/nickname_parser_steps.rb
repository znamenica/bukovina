Допустим(/^есть строк[аи] прозвища:$/) do |string|
   @namer = Bukovina::Parsers::NickName.new
   @res = @namer.parse( YAML.load( string ) ) ; end
