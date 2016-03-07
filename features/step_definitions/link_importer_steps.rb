Допустим(/^есть обработанные данные вики ссылки:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::WikiLink.new( attrs ) ; end

То(/^будет создана модель ссылки с аттрибутами:$/) do |table|
   attrs = table.rows_hash
   expect( Link.where( attrs ).count ).to be_eql( 1 ) ; end
