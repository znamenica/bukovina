Допустим(/^есть событие "([^"]*)"$/) do |date|
   create( :event, happened_at: date ) ;end

Допустим(/^есть обработанные данные помина:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::Mention.new( attrs ) ; end
