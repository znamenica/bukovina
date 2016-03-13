Допустим(/^есть строк[аи] прозвища:$/) do |string|
   @parser = Bukovina::Parsers::NickName.new
   @res = @parser.parse( YAML.load( string ) ) ; end
