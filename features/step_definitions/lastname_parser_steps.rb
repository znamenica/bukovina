Допустим(/^есть строк[аи] фамилии:$/) do |string|
   @parser = Bukovina::Parsers::LastName.new
   @res = @parser.parse( YAML.load( string ) ) ; end
