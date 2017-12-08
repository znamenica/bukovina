Допустим(/^есть событие "([^"]*)"$/) do |date|
   create( :event, happened_at: date ) ;end

Допустим(/^есть (другое )?событие "([^"]*)" в "([^"]*)" для памяти "([^"]*)"$/) do |other, type, date, short_name|
   memory = Memory.by_short_name(short_name).first
   attrs = { type: type, happened_at: date, memory_id: memory.id }
   attrs[ :type_number ] = '1' if other
   create( :event, attrs ) ;end

Допустим(/^есть обработанные данные помина:$/) do |string|
   attrs = YAML.load( string )
   @importer = Bukovina::Importers::Memo.new( attrs ) ; end

То(/^будут созданы модели помина с аттрибутами:$/) do |table|
   attrs_list = []
   table.each_cells_row do |row|
      attrs_list << row.map do |cell|
         value = YAML.load( cell.value )
         value && value.to_a[ 0 ] || nil ; end.compact.to_h

      attrs_list.each do |attrs|
         made_attrs, joins = make_attrs_for( attrs, Memo )
         binding.pry if ENV['DEBUG']
         relation = Memo.joins( joins ).where( made_attrs )
         expect( relation.size ).to be_eql( 1 ) ;end;end;end
