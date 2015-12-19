Допустим(/^есть строка имени:$/) do |string|
   namer = Bukovina::Parsers::Name.new
   @res = namer.parse( string.strip )
end

То(/^обработанные данные имени будут выглядеть как:$/) do |table|
   table.hashes.map! {|x| x.symbolize_keys }
   expect( @res[ :name ] ).to be_eql( table.hashes )
end

То(/^обработанные данные памятного имени будут выглядеть как:$/) do |table|
   table.hashes.map! {|x| x.symbolize_keys }
   res = filter_array @res[ :memory_name ], except: :name
   expect( res ).to match_array( table.hashes )
end
