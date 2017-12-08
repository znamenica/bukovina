Допустим(/^есть строка служебной ссылки:$/) do |string|
   @parser = Bukovina::Parsers::ServiceLink.new
   @res = @parser.parse( YAML.load( string ), target: @short_name ) ; end

Допустим(/^есть местный файл службы "([^"]*)" памяти "([^"]*)":$/) do |service_name, short_name, string|
   data = YAML.load( string )
   FileUtils.mkdir_p( File.join( @workdir, short_name ) )
   file = File.join( @workdir, short_name, "#{service_name}.ру_ро.yml" )
   File.open( file, 'w' ) { |f| f.puts(data.to_yaml) } ; end

Допустим(/^есть местный (украинский|румынский|сербский|иверский|английский) файл службы "([^"]*)" памяти "([^"]*)":$/) do |language, service_name, short_name, string|
   (la, al) = language_code_for( language )
   data = YAML.load( string )
   FileUtils.mkdir_p( File.join( @workdir, short_name ) )
   file = File.join( @workdir, short_name, "#{service_name}.#{la}_#{al}.yml" )
   File.open( file, 'w' ) { |f| f.puts(data.to_yaml) } ; end

Допустим(/^есть иной местный файл службы "([^"]*)" памяти "([^"]*)":$/) do |service_name, short_name, string|
   data = YAML.load( string )
   FileUtils.mkdir_p( File.join( @workdir, short_name ) )
   file = File.join( @workdir, short_name, "#{service_name}(1).ру_ро.yml" )
   File.open( file, 'w' ) { |f| f.puts(data.to_yaml) } ; end

Допустим(/^есть местный файл службы "([^"]*)" памяти "([^"]*)" в hip:$/) do |service_name, short_name, string|
   FileUtils.mkdir_p( File.join( @workdir, short_name ) )
   file = File.join( @workdir, short_name, "#{service_name}.цс.hip" )
   File.open( file, 'w' ) { |f| f.puts( string ) } ; end

Допустим(/^задействуем память "([^"]*)"$/) do |short_name|
   @short_name = short_name
   begin
      Dir.chdir( File.join( @workdir, short_name ) )
   rescue Errno::ENOENT ;end;end

То(/^обработанные данные службы будут выглядеть как:$/) do |string|
   # binding.pry
   expect( @res[ :service ].to_yaml.strip ).to be_eql( string.to_s ) ; end

То(/^обработанных данных службы не будет$/) do
   expect( @res[ :service ] ).to be_blank ; end

То(/^обработанных данных ссылки не будет$/) do
   expect( @res[ :link ] ).to be_blank ; end

То(/^обработанные данные ровнотекстовой службы будут выглядеть как:$/) do |string|
   expect( @res[ :plain_service ].to_yaml.strip ).to be_eql( string.to_s ) ; end
