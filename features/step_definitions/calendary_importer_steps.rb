Допустим(/^есть обработанные данные календаря:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::Calendary.new( attrs ) ; end
