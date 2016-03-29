Допустим(/^есть обработанные данные службы:$/) do |string|
   @importer = Bukovina::Importers::Service.new( YAML.load( string ) ) ; end
