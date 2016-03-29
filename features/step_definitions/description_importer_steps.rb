Допустим(/^есть обработанные данные описания:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::Description.new( attrs ) ; end
