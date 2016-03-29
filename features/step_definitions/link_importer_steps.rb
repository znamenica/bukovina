Допустим(/^есть обработанные данные вики ссылки:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::WikiLink.new( attrs ) ; end

Допустим(/^есть обработанные данные иконной ссылки:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::IconLink.new( attrs ) ; end
