Допустим(/^есть строка служебной ссылки:$/) do |string|
   @parser = Bukovina::Parsers::ServiceLink.new
   @res = @parser.parse( YAML.load( string ) ) ; end

Допустим(/^есть местный файл службы "([^"]*)" памяти "([^"]*)":$/) do |service_name, short_name, string|
   data = YAML.load( string )
   FileUtils.mkdir_p( File.join( @workdir, short_name ) )
   file = File.join( @workdir, short_name, "#{service_name}.ро_ру.yml" )
   File.open( file, 'w' ) { |f| f.puts(data.to_yaml) } ; end

Допустим(/^есть иной местный файл службы "([^"]*)" памяти "([^"]*)":$/) do |service_name, short_name, string|
   data = YAML.load( string )
   FileUtils.mkdir_p( File.join( @workdir, short_name ) )
   file = File.join( @workdir, short_name, "#{service_name}(1).ро_ру.yml" )
   File.open( file, 'w' ) { |f| f.puts(data.to_yaml) } ; end

Допустим(/^есть местный файл службы "([^"]*)" памяти "([^"]*)" на ином языке:$/) do |service_name, short_name, string|
   data = YAML.load( string )
   FileUtils.mkdir_p( File.join( @workdir, short_name ) )
   file = File.join( @workdir, short_name, "#{service_name}.re_en.yml" )
   File.open( file, 'w' ) { |f| f.puts(data.to_yaml) } ; end

Допустим(/^есть местный файл службы "([^"]*)" памяти "([^"]*)" в hip:$/) do |service_name, short_name, string|
   FileUtils.mkdir_p( File.join( @workdir, short_name ) )
   file = File.join( @workdir, short_name, "#{service_name}.цс.hip" )
   File.open( file, 'w' ) { |f| f.puts( string ) } ; end

Допустим(/^задействуем память "([^"]*)"$/) do |short_name|
   Dir.chdir( File.join( @workdir, short_name ) ) ; end

То(/^обработанные данные службы будут выглядеть как:$/) do |string|
   expect( @res[ :service ].to_yaml.strip ).to be_eql( string.to_s ) ; end

То(/^обработанных данных службы не будет$/) do
   expect( @res[ :service ] ).to be_blank ; end

То(/^обработанных данных ссылки не будет$/) do
   expect( @res[ :link ] ).to be_blank ; end

То(/^обработанные данные ровнотекстовой службы будут выглядеть как:$/) do |string|
   expect( @res[ :plain_service ].first.strip ).to be_eql( string.to_s ) ; end