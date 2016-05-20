Допустим(/^есть обработанные данные события:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::Event.new( attrs ) ; end

Допустим(/^есть место "([^"]*)"$/) do |place|
   FactoryGirl.create( :place, ru_description: place ) ;end

