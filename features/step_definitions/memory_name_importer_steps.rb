Допустим(/^есть некая память$/) do
   FactoryGirl.create( :memory ) ; end

Допустим(/^есть обработанные данные памятного имени:$/) do |string|
   attrs = YAML.load( string )
   o_attrs = { memory: Memory.last }
   @importer = Bukovina::Importers::MemoryName.new( attrs, o_attrs ) ; end

То(/^будут созданы модели памятного имени с аттрибутами:$/) do |table|
   hashes = table.hashes.map do |h|
      h.map do |k,v|
         value = YAML.load( v )
         value && [ k, value ] || nil
         end.compact.to_h ; end

   hashes.each do |h|
      h[ 'name' ] = Name.where( text: h.delete( 'name' ) ).first
      expect( MemoryName.where( h ).count ).to be_eql( 1 ) ; end ; end
