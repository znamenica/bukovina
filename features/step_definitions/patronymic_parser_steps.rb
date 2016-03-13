Допустим(/^есть строк[иа] отчества:$/) do |string|
   @parser = Bukovina::Parsers::Patronymic.new
   @res = @parser.parse( YAML.load( string ) ) ; end
