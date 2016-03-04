Допустим(/^есть строк[иа] описания:$/) do |string|
   @parser = Bukovina::Parsers::Description.new
   @res = @parser.parse( YAML.load( string ) ) ; end

То(/^обработанные данные описания будут выглядеть как:$/) do |string|
   expect( @res[ :description ].to_yaml.strip ).to be_eql( string.to_s ) ; end
