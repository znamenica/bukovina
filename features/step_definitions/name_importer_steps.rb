Допустим(/^есть обработанные данные имени:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::Name.new( attrs ) ; end

То(/^будут созданы модели имени с аттрибутами:$/) do |table|
   attrs_list = []
   table.each_cells_row do |row|
      attrs_list << row.map do |cell|
         value = YAML.load( cell.value )
         value && value.to_a[ 0 ] || nil ; end.compact.to_h ; end

   attrs_list.each do |attrs|
      bond_to = attrs.delete( :bond_to )
      binding.pry if ENV['DEBUG']
      expect( Name.where( attrs ).count ).to be_eql( 1 )
      if bond_to
         expect( Name.where( attrs ).first.bond_to.text ).to be_eql( bond_to )
         ; end ; end ; end
