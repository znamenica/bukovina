Допустим(/^есть строк[иа] отчества:$/) do |string|
   @namer = Bukovina::Parsers::Patronymic.new
   @res = @namer.parse( YAML.load( string ) ) ; end
