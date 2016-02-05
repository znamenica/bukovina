Допустим(/^есть обработанные данные имени:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::Name.new( attrs ) ; end

Если(/^импортируем их$/) do
   @importer.import ; end

То(/^будет создана модель имени с аттрибутами:$/) do |table|
   attrs = table.rows_hash
   if attrs.has_key?( 'language_code' )
      value = /^:(.*)/ =~ attrs[ 'language_code' ] && $1.to_sym ||
         attrs[ 'language_code' ]
      attrs[ 'language_code' ] = Name.language_codes[ value ] ; end
   expect( Name.where( attrs ).count ).to be_eql( 1 ) ; end

То(/^будут созданы модели имени с аттрибутами:$/) do |table|
   attrs_list = []
   table.each_cells_row do |row|
      attrs_list << row.map do |cell|
         value = YAML.load( cell.value )
         value && value.to_a[ 0 ] || nil ; end.compact.to_h ; end

   attrs_list.each do |attrs|
      if attrs.has_key?( :language_code )
         value = /^:(.*)/ =~ attrs[ :language_code ] && $1.to_sym ||
            attrs[ :language_code ]
         attrs[ :language_code ] = Name.language_codes[ value ] ; end

      similar_to = attrs.delete( :similar_to )
      expect( Name.where( attrs ).count ).to be_eql( 1 )
      if similar_to
         expect( Name.where( attrs ).first.similar_to.text ).to be_eql( similar_to )
         ; end ; end ; end
