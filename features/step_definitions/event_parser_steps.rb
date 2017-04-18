Допустим(/^есть (?:словцик события|набор событий):$/) do |string|
   @parser = Bukovina::Parsers::Event.new
   @res = @parser.parse( YAML.load( string ), target: @short_name )
   if ! @res
      puts @parser.inspect ; end ; end

То(/^обработанные данные события будут выглядеть как:$/) do |string|
   expect( @res.to_yaml.strip ).to be_eql( string.to_s ) ; end
