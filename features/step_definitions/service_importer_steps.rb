Допустим(/^есть обработанные данные службы:$/) do |string|
   @importer = Bukovina::Importers::Service.new( YAML.load( string ) ) ; end

То(/^будет создана модель службы с аттрибутами:$/) do |table|
   attrs = table.rows_hash
   expect( Service.where( attrs ).count ).to be_eql( 1 ) ;end

То(/^будет создана модель тропаря с аттрибутами:$/) do |table|
   attrs = table.rows_hash
   expect( Troparion.where( attrs ).count ).to be_eql( 1 ) ;end

То(/^модель службы с аттрибутами будет относиться к памяти "([^"]*)":$/) do |short_name, table|
   attrs = table.rows_hash
   memory = Memory.find_by_short_name( short_name )
   expect( Service.where( attrs ).first.memory ).to be_eql( memory ) ;end

То(/^модель тропаря с аттрибутами будет относиться к службе "([^"]*)":$/) do |name, table|
   attrs = table.rows_hash
   service = Service.find_by_name( name )
   expect( Troparion.where( attrs ).first.services ).to include( service ) ;end
