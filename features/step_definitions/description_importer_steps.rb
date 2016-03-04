Допустим(/^есть обработанные данные описания:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::Description.new( attrs ) ; end

То(/^будет создана модель описания с аттрибутами:$/) do |table|
   attrs = table.rows_hash
   expect( Description.where( attrs ).count ).to be_eql( 1 ) ; end
