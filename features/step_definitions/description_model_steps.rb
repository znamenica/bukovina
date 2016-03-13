Допустим(/^есть модель описания$/) do
   @model = Description.new ; end

Допустим(/^создадим новое описание с полями:$/) do |table|
   find_or_create( Description, table.rows_hash ) ; end

То(/^русское описание "([^"]*)" будет существовать$/) do |name|
   it = Description.where( text: name ).first
   expect( it ).to be_persisted ; end

То(/^свойства "([^"]*)" модели не могут быть пустыми$/) do |props|
   props.split(/,\s+/).each do |prop|
      expect( @model ).to validate_presence_of( prop ) ; end ; end

То(/^свойство "([^"]*)" модели является перечислителем$/) do |prop|
   expect( @model ).to define_enum_for( prop ) ; end

То(/^свойство "([^"]*)" модели есть отношение к памяти$/) do |prop|
   expect( @model ).to belong_to( prop ).class_name( :Memory ) ; end

То(/^свойство "([^"]*)" модели есть отношение к описываемому$/) do |prop|
   expect( @model ).to belong_to( prop ) ; end

То(/^таблица модели имеет столб(?:ец|цы) "([^"]*)" рода "(целый|строка)"$/) do |names, type_name|
   type = get_type( type_name )
   names.split( /,\s+/ ).each do |name|
      expect( @model ).to have_db_column( name ).of_type( type ) ; end ; end

То(/^получим ошибку удвоения попытавшись создать новое описание с полями:$/) do |table|
   expect{ find_or_create( Description, table.rows_hash ) }.to raise_error( ActiveRecord::RecordNotUnique ) ; end
