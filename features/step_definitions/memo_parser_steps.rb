Допустим(/^есть (?:словцик помина|набор поминов):$/) do |string|
   @parser = Bukovina::Parsers::Memo.new
   @res = @parser.parse( YAML.load( string ), target: @short_name )
   if ! @res
      puts @parser.inspect ; end ; end

То(/^обработанные данные помина будут выглядеть как:$/) do |string|
   binding.pry if ENV['DEBUG']
   expect( @res[:memos].to_yaml.strip ).to be_eql( string.to_s ) ; end
